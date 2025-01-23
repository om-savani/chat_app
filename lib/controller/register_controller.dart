import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../routes/app_routes.dart';
import '../services/firebase_services.dart';

class RegisterController extends GetxController {
  // Sign up with email and password
  void register({required String email, required String password}) {
    Future<User?> user =
        FirebaseServices.firebaseServices.register(email, password);
    user.then((value) {
      if (value != null) {
        Logger().i('Registration successful. Navigating to the home screen.');
        Get.snackbar('Success', 'Register Successfully');
        Get.back();
      } else {
        Get.snackbar('Error', 'Register Failed');
      }
    }).catchError((e) {
      Logger().e('Error during registration: $e');
      Get.snackbar('Error', 'Failed to register: $e');
    });
  }
}
