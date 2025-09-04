import 'dart:developer' as dev;
import 'package:cutcy/home/appointment/appointment_details_screen.dart';
import 'package:cutcy/home/appointment/appointment_response_model.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final Rxn<String> lastError = Rxn<String>();

  // Real appointment lists
  final RxList<Appointment> upcoming = <Appointment>[].obs;
  final RxList<Appointment> ongoing = <Appointment>[].obs;
  final RxList<Appointment> past = <Appointment>[].obs;

  final Rxn<Appointment> selectedAppointment = Rxn<Appointment>();

  @override
  void onInit() {
    super.onInit();
    loadAllAppointments();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    // Load data for the selected tab if needed
    switch (index) {
      case 0:
        if (upcoming.isEmpty) loadUpcomingAppointments();
        break;
      case 1:
        if (ongoing.isEmpty) loadOngoingAppointments();
        break;
      case 2:
        if (past.isEmpty) loadPastAppointments();
        break;
    }
  }

  void selectAppointment(Appointment appointment) {
    selectedAppointment.value = appointment;
    Get.to(() => AppointmentDetailsScreen());
  }

  // Load all appointments at once
  Future<void> loadAllAppointments() async {
    await Future.wait([loadUpcomingAppointments(), loadOngoingAppointments(), loadPastAppointments()]);
  }

  // Load past appointments
  Future<void> loadPastAppointments() async {
    try {
      isLoading.value = true;
      lastError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      final response = await apiService.request(ApiConfig.userPastAppointments, method: "GET");

      dev.log("Past appointments response: $response");

      // ✅ Handle both success and "no data found" cases
      if (response is Map<String, dynamic>) {
        if (response["success"] == true && response["data"] != null) {
          final appointmentResponse = AppointmentResponse.fromJson(response);
          past.value = appointmentResponse.data ?? [];
          dev.log("Loaded ${past.length} past appointments");
        } else if (response["success"] == false && response["data"] == null) {
          // Handle "no data found" case (404 with success: false)
          past.value = [];
          dev.log("No past appointments found");
        } else {
          past.value = [];
          lastError.value = "Failed to load past appointments";
        }
      } else {
        past.value = [];
        lastError.value = "Invalid response format";
      }
    } catch (e) {
      dev.log("Error loading past appointments: $e");
      // ✅ Don't set error for "no data found" cases
      if (!e.toString().contains("No") && !e.toString().contains("found")) {
        lastError.value = "Error loading past appointments: $e";
      }
      past.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Load upcoming appointments
  Future<void> loadUpcomingAppointments() async {
    try {
      isLoading.value = true;
      lastError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      final response = await apiService.request(ApiConfig.userUpcomingAppointments, method: "GET");

      dev.log("Upcoming appointments response: $response");

      // ✅ Handle both success and "no data found" cases
      if (response is Map<String, dynamic>) {
        if (response["success"] == true && response["data"] != null) {
          final appointmentResponse = AppointmentResponse.fromJson(response);
          upcoming.value = appointmentResponse.data ?? [];
          dev.log("Loaded ${upcoming.length} upcoming appointments");
        } else if (response["success"] == false && response["data"] == null) {
          // Handle "no data found" case (404 with success: false)
          upcoming.value = [];
          dev.log("No upcoming appointments found");
        } else {
          upcoming.value = [];
          lastError.value = "Failed to load upcoming appointments";
        }
      } else {
        upcoming.value = [];
        lastError.value = "Invalid response format";
      }
    } catch (e) {
      dev.log("Error loading upcoming appointments: $e");
      // ✅ Don't set error for "no data found" cases
      if (!e.toString().contains("No") && !e.toString().contains("found")) {
        lastError.value = "Error loading upcoming appointments: $e";
      }
      upcoming.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Load ongoing appointments
  Future<void> loadOngoingAppointments() async {
    try {
      isLoading.value = true;
      lastError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      final response = await apiService.request(ApiConfig.userOngoingAppointments, method: "GET");

      dev.log("Ongoing appointments response: $response");

      // ✅ Handle both success and "no data found" cases
      if (response is Map<String, dynamic>) {
        if (response["success"] == true && response["data"] != null) {
          final appointmentResponse = AppointmentResponse.fromJson(response);
          ongoing.value = appointmentResponse.data ?? [];
          dev.log("Loaded ${ongoing.length} ongoing appointments");
        } else if (response["success"] == false && response["data"] == null) {
          // Handle "no data found" case (404 with success: false)
          ongoing.value = [];
          dev.log("No ongoing appointments found");
        } else {
          ongoing.value = [];
          lastError.value = "Failed to load ongoing appointments";
        }
      } else {
        ongoing.value = [];
        lastError.value = "Invalid response format";
      }
    } catch (e) {
      dev.log("Error loading ongoing appointments: $e");
      // ✅ Don't set error for "no data found" cases
      if (!e.toString().contains("No") && !e.toString().contains("found")) {
        lastError.value = "Error loading ongoing appointments: $e";
      }
      ongoing.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh all appointments
  Future<void> refreshAppointments() async {
    await loadAllAppointments();
  }
}
