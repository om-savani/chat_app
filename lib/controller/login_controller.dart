import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../routes/app_routes.dart';
import '../services/firestore_service.dart';

class LoginController extends GetxController {
  RxBool isShowPassword = true.obs;

  void changeShowPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  // Login New User
  Future<void> login({required String email, required String password}) async {
    String? msg =
        await FirebaseServices.firebaseServices.login(email, password);
    if (msg == 'Success') {
      Get.offNamed(AppRoutes.home);
      Get.snackbar('Success', 'Login Successfully');
    }
  }

// Google Login
  Future<void> loginWithGoogle() async {
    String? user = await FirebaseServices.firebaseServices.loginWithGoogle();
    if (user == 'Success') {
      Get.offNamed(AppRoutes.home);
      var userdata = FirebaseServices.firebaseServices.currentUser;
      if (userdata != null) {
        FireStoreService.instance.addUser(
          user: UserModel(
            uid: userdata.uid,
            name: userdata.displayName!,
            email: userdata.email!,
            photoUrl: userdata.photoURL!,
          ),
        );
      }
      Get.snackbar('Success', 'Login Successfully');
    }
  }

// Anonymous Login
  void loginAnonymous() {
    Future<User?> user = FirebaseServices.firebaseServices.loginAnonymous();
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        FireStoreService.instance.addUser(
          user: UserModel(
            name: value.displayName!,
            uid: value.uid,
            email: value.email!,
            photoUrl:
                "https://avatars.mds.yandex.net/i?id=d36ac640ce13876899fd2633f75ec08f0cb05b5b-9226569-images-thumbs&ref=rim&n=33&w=250&h=250",
          ),
        );
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Anonymous login failed.');
      }
    }).catchError((e) {
      Logger().e('Error during anonymous login: $e');
      Get.snackbar('Error', 'Anonymous login failed: $e');
    });
  }

  void getUser() {}
}
