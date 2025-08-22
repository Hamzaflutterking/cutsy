import 'package:cutcy/auth/auth_controller.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Stays in memory for the whole app lifecycle
    Get.put<AuthController>(AuthController(), permanent: true);
    // If you prefer it to be recreated on demand after dispose, use:
    // Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
