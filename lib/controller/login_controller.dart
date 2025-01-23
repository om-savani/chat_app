import 'package:chat_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../routes/app_routes.dart';

class LoginController extends GetxController {
  // Login New User
  void login({required String email, required String password}) {
    Future<User?> user =
        FirebaseServices.firebaseServices.login(email, password);
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Login Failed');
      }
    }).catchError((e) {
      Logger().e('Error during login: $e');
      Get.snackbar('Error', 'Login failed: $e');
    });
  }

// Google Login
  void loginWithGoogle() {
    Future<User?> user = FirebaseServices.firebaseServices.loginWithGoogle();
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Google login failed.');
      }
    }).catchError((e) {
      Logger().e('Error during Google login: $e');
      Get.snackbar('Error', 'Google login failed: $e');
    });
  }

// Anonymous Login
  void loginAnonymous() {
    Future<User?> user = FirebaseServices.firebaseServices.loginAnonymous();
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Anonymous login failed.');
      }
    }).catchError((e) {
      Logger().e('Error during anonymous login: $e');
      Get.snackbar('Error', 'Anonymous login failed: $e');
    });
  }
}
