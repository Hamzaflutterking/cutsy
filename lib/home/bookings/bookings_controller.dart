import 'dart:developer' as dev;

import 'package:cutcy/main.dart';
import 'package:cutcy/services/Exceptions/app_exceptions.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  // ---- Barber / location ----
  final Rxn<String> barberId = Rxn<String>();
  final Rxn<String> locationName = Rxn<String>();
  final Rxn<double> locationLat = Rxn<double>();
  final Rxn<double> locationLng = Rxn<double>();
  void setBarberContext({required String id, String? locName, double? lat, double? lng}) {
    barberId.value = id;
    if (locName != null) locationName.value = locName;
    if (lat != null) locationLat.value = lat;
    if (lng != null) locationLng.value = lng;
  }

  // ---- Selected slot ----
  final Rxn<String> selectedDay = Rxn<String>(); // "SAT"
  final Rxn<String> selectedStart = Rxn<String>(); // "05:00 am"
  final Rxn<String> selectedEnd = Rxn<String>(); // "06:00 am"
  void setSlot({required String day, required String start, required String end}) {
    selectedDay.value = day;
    selectedStart.value = start;
    selectedEnd.value = end;
  }

  // ---- Services (IDs) ----
  final selectedServices = <String>[].obs;
  final serviceQuantities = <String, int>{}.obs; // id -> qty
  final serviceMeta = <String, Map<String, dynamic>>{}.obs; // id -> {title, price(double)}

  void toggleServiceById(String id, {required String title, required double price}) {
    serviceMeta[id] = {"title": title, "price": price};
    serviceQuantities[id] = serviceQuantities[id] ?? 1;
    if (selectedServices.remove(id)) {
      serviceQuantities.remove(id);
      serviceMeta.remove(id);
    } else {
      selectedServices.add(id);
      dev.log("Service added: $id, $title, $price");
    }
  }

  bool isSelected(String id) => selectedServices.contains(id);
  void increment(String id) => selectedServices.contains(id) ? serviceQuantities[id] = (serviceQuantities[id] ?? 1) + 1 : null;
  void decrement(String id) {
    if (!selectedServices.contains(id)) return;
    final c = serviceQuantities[id] ?? 1;
    serviceQuantities[id] = c > 1 ? c - 1 : 1;
  }

  // ---- Totals ----
  final double discount = 10.00;
  final double platformFee = 5.00;
  double get subTotal {
    double s = 0;
    for (final id in selectedServices) {
      final p = (serviceMeta[id]?['price'] as double?) ?? 0;
      final q = serviceQuantities[id] ?? 1;
      s += p * q;
    }
    return s;
  }

  double get total => subTotal - discount + platformFee;

  // ---- API payload & call ----
  Map<String, dynamic> buildPayloadForApi() {
    final payload = {
      "barberId": barberId.value,
      "day": selectedDay.value ?? '', // Keep original format "SAT"
      "startTime": selectedStart.value ?? '', // Keep original format "06:00 am"
      "endTime": selectedEnd.value ?? '', // Keep original format "07:00 am"
      "amount": total.toStringAsFixed(0), // server expects string
      "locationName": locationName.value,
      "locationLat": locationLat.value,
      "locationLng": locationLng.value,
      "services": selectedServices.toList(), // Send as array of service IDs
    };

    return payload;
  }

  final isPlacing = false.obs;
  final Rxn<String> lastError = Rxn<String>();
  final Rxn<String> selectedPaymentMethodId = Rxn<String>();

  // Step 1: Check if user has existing payment methods
  Future<List<Map<String, dynamic>>?> checkExistingPaymentMethods() async {
    try {
      apiService.setToken(StorageService.to.getString("token") ?? "");

      final response = await apiService.request(ApiConfig.userShowPaymentMethods, method: "GET");

      if (response is Map && response["success"] == true && response["data"] != null) {
        final data = response["data"] as List;
        dev.log("Found ${data.length} existing payment methods");
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      dev.log("Error checking payment methods: $e");
      return [];
    }
  }

  // Step 2: Add payment method using Setup Intent (if no cards exist)
  Future<String?> addPaymentMethodWithSetupIntent() async {
    try {
      isPlacing.value = true;
      lastError.value = null;

      // Create Setup Intent on your server
      apiService.setToken(StorageService.to.getString("token") ?? "");

      final setupResponse = await apiService.request(
        ApiConfig.userAddPaymentMethod, // This should create a setup intent
        method: "POST",
      );

      String? clientSecret;
      if (setupResponse is Map && setupResponse["clientSecret"] != null) {
        clientSecret = setupResponse["clientSecret"].toString();
      } else {
        lastError.value = "Failed to initialize payment setup";
        return null;
      }

      // Initialize Stripe payment sheet for adding payment method
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          merchantDisplayName: 'Cutsy',
          style: ThemeMode.dark,
          billingDetails: BillingDetails(email: StorageService.to.getString("userEmail"), name: StorageService.to.getString("userName")),
        ),
      );

      // Present payment sheet for adding card
      await Stripe.instance.presentPaymentSheet();

      // After successful setup, get the new payment methods
      final paymentMethods = await checkExistingPaymentMethods();
      if (paymentMethods != null && paymentMethods.isNotEmpty) {
        final latestPaymentMethod = paymentMethods.first;
        dev.log("Payment method added successfully: ${latestPaymentMethod['id']}");
        return latestPaymentMethod['id'] as String;
      } else {
        lastError.value = "Failed to retrieve payment method after setup";
        return null;
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        lastError.value = "Payment setup was cancelled";
      } else {
        dev.log("Payment setup failed: ${e.error.message}");
        lastError.value = "Payment setup failed: ${e.error.message}";
      }
      return null;
    } catch (e) {
      dev.log("Error adding payment method: $e");
      lastError.value = "Failed to add payment method: $e";
      return null;
    } finally {
      isPlacing.value = false;
    }
  }

  // Step 3: Create booking and get client secret (no payment method ID needed)
  Future<String?> createBookingAndGetClientSecret() async {
    try {
      isPlacing.value = true;
      lastError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      final payload = buildPayloadForApi(); // ✅ Simple payload without payment method

      dev.log("Creating booking with payload: $payload");

      final response = await apiService.request(ApiConfig.userCreateBookingAndPayment, method: "POST", body: payload);

      // Handle the API response structure
      if (response is Map && response["success"] == true && response["data"] != null) {
        final data = response["data"] as Map<String, dynamic>;

        // Extract client secret from the nested response structure
        if (data["paymentIntentRes"] != null && data["paymentIntentRes"]["clientSecret"] != null) {
          final clientSecret = data["paymentIntentRes"]["clientSecret"] as String;
          dev.log("Booking created, received client secret: ${clientSecret.substring(0, 20)}...");
          return clientSecret;
        }
      }

      lastError.value = "Booking created but no payment client secret received";
      return null;
    } on UnauthorizedException catch (e) {
      lastError.value = "Authentication failed: ${e.toString()}";
      return null;
    } on NotFoundException catch (e) {
      lastError.value = "Service not found: ${e.toString()}";
      return null;
    } catch (e) {
      dev.log("Error creating booking: $e");
      lastError.value = "Booking failed: $e";
      return null;
    } finally {
      isPlacing.value = false;
    }
  }

  // Step 4: Process payment with client secret
  Future<bool> processPaymentWithClientSecret(String clientSecret, {bool hasExistingCards = false}) async {
    try {
      isPlacing.value = true;
      lastError.value = null;

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Cutsy',
          style: ThemeMode.dark,
          // Only add billing details if user doesn't have existing cards
          billingDetails: !hasExistingCards
              ? BillingDetails(email: StorageService.to.getString("userEmail"), name: StorageService.to.getString("userName"))
              : null,
          // Enable Apple Pay and Google Pay
          // applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   testEnv: true, // Set to false in production
          // ),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      dev.log("Payment completed successfully");
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        lastError.value = "Payment was cancelled";
      } else {
        dev.log("Payment failed: ${e.error.message}");
        lastError.value = "Payment failed: ${e.error.message}";
      }
      return false;
    } catch (e) {
      dev.log("Error processing payment: $e");
      lastError.value = "Payment processing failed: $e";
      return false;
    } finally {
      isPlacing.value = false;
    }
  }

  // Method to proceed with existing cards (called from bottom sheet or directly)
  Future<bool> proceedWithPayment({bool hasExistingCards = false}) async {
    try {
      // Step 1: Create booking and get client secret
      final clientSecret = await createBookingAndGetClientSecret();
      if (clientSecret == null) {
        return false; // Error already set in createBookingAndGetClientSecret
      }

      // Step 2: Process payment with client secret
      final paymentSuccess = await processPaymentWithClientSecret(clientSecret, hasExistingCards: hasExistingCards);
      return paymentSuccess;
    } catch (e) {
      dev.log("Error proceeding with payment: $e");
      lastError.value = "Booking and payment failed: $e";
      return false;
    }
  }

  // Main method: Complete booking and payment flow
  Future<bool> processPaymentWithStripe() async {
    if (barberId.value == null || selectedDay.value == null || selectedStart.value == null || selectedEnd.value == null || selectedServices.isEmpty) {
      lastError.value = "Please select a time and at least one service.";
      return false;
    }

    try {
      isPlacing.value = true;
      lastError.value = null;

      // Step 1: Check if user has existing payment methods
      final existingPaymentMethods = await checkExistingPaymentMethods();

      if (existingPaymentMethods == null || existingPaymentMethods.isEmpty) {
        // No cards attached - need to add payment method first
        dev.log("No payment methods found, adding new payment method");
        final paymentMethodId = await addPaymentMethodWithSetupIntent();
        if (paymentMethodId == null) {
          return false; // Error already set in addPaymentMethodWithSetupIntent
        }

        // After adding card, proceed with payment
        return await proceedWithPayment(hasExistingCards: false);
      } else {
        // Cards exist - proceed directly with payment
        dev.log("Found existing payment methods, proceeding with payment");
        return await proceedWithPayment(hasExistingCards: true);
      }
    } catch (e) {
      dev.log("Error in complete payment flow: $e");
      lastError.value = "Booking and payment failed: $e";
      return false;
    } finally {
      isPlacing.value = false;
    }
  }

  // Keep the old method for backward compatibility
  Future createBookingAndPayment() async {
    return processPaymentWithStripe();
  }
}
