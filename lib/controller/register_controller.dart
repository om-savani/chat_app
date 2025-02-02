import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_services.dart';

class RegisterController extends GetxController {
  RxBool isShowPassword = true.obs;
  RxBool isShowCPassword = true.obs;
  File? imageFile;

  void changeShowPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  void changeShowCPassword() {
    isShowCPassword.value = !isShowCPassword.value;
  }

  // Sign up with email and password
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String image,
  }) async {
    String? user =
        await FirebaseServices.firebaseServices.register(email, password);
    if (user == 'Success') {
      UserModel userModel = UserModel(
        email: email,
        name: name,
        photoUrl: image,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
      FireStoreService.instance.addUser(user: userModel);
      Get.snackbar(
        'Success',
        'Register Successfully',
      );
      Get.back();
    } else {
      Get.snackbar(
        'Error',
        user,
      );
    }
  }

  Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (xFile != null) {
      imageFile = File(xFile.path);
    }

    update();
  }
}
