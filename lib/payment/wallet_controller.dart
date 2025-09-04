import 'dart:developer' as dev;

import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final isLoading = false.obs;
  final isAddingCard = false.obs;
  final RxList<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[].obs;
  final Rxn<String> lastError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }

  @override
  void onReady() {
    super.onReady();
    print("WalletController onReady called"); // ✅ Add this for debugging
    // This is called after onInit and after the widget is rendered
    loadPaymentMethods();
  }

  // Load existing payment methods
  Future<void> loadPaymentMethods() async {
    try {
      isLoading.value = true;
      lastError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      final response = await apiService.request(ApiConfig.userShowPaymentMethods, method: "GET");

      if (response is Map && response["success"] == true && response["data"] != null) {
        final data = response["data"] as List;
        paymentMethods.value = data.cast<Map<String, dynamic>>();
        dev.log("Loaded ${paymentMethods.length} payment methods");
      } else {
        paymentMethods.value = [];
      }
    } catch (e) {
      dev.log("Error loading payment methods: $e");
      lastError.value = "Failed to load payment methods";
      paymentMethods.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Add new payment method
  Future<bool> addPaymentMethod() async {
    try {
      isAddingCard.value = true;
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
        return false;
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

      // After successful setup, reload payment methods
      await loadPaymentMethods();

      showCustomSnackbar(title: "Success!", message: "Card added successfully");

      dev.log("Payment method added successfully");
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        lastError.value = "Card setup was cancelled";
      } else {
        dev.log("Card setup failed: ${e.error.message}");
        lastError.value = "Card setup failed: ${e.error.message}";
        showCustomSnackbar(title: "Error", message: lastError.value ?? "Failed to add card");
      }
      return false;
    } catch (e) {
      dev.log("Error adding payment method: $e");
      lastError.value = "Failed to add card: $e";
      showCustomSnackbar(title: "Error", message: "Failed to add card");
      return false;
    } finally {
      isAddingCard.value = false;
    }
  }

  // Delete payment method (optional)
  // Future<bool> deletePaymentMethod(String paymentMethodId) async {
  //   try {
  //     isLoading.value = true;

  //     apiService.setToken(StorageService.to.getString("token") ?? "");

  //     final response = await apiService.request(
  //       '${ApiConfig.userDeletePaymentMethod}/$paymentMethodId', // You'll need to add this endpoint
  //       method: "DELETE",
  //     );

  //     if (response is Map && response["success"] == true) {
  //       await loadPaymentMethods(); // Reload the list
  //       showCustomSnackbar(title: "Success!", message: "Card removed successfully");
  //       return true;
  //     } else {
  //       lastError.value = "Failed to remove card";
  //       return false;
  //     }
  //   } catch (e) {
  //     dev.log("Error deleting payment method: $e");
  //     lastError.value = "Failed to remove card";
  //     showCustomSnackbar(title: "Error", message: "Failed to remove card");
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
