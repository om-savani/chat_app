import 'dart:io';
import 'dart:ui';

import 'package:chat_app/controller/register_controller.dart';
import 'package:chat_app/services/api_service.dart';
import 'package:chat_app/utils/extensions/sizedbox_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/background/splash_background.png'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: registerController.pickImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.greenAccent,
                        backgroundImage: registerController.imageFile != null
                            ? FileImage(registerController.imageFile!)
                            : null,
                        child: registerController.imageFile == null
                            ? const Icon(Icons.camera_alt,
                                color: Colors.black, size: 30)
                            : null,
                      ),
                    ),
                    20.sh,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Create an Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          16.sh,
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person,
                                  color: Colors.white70),
                              hintText: 'Username',
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Username';
                              }
                              return null;
                            },
                          ),
                          12.sh,
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email,
                                  color: Colors.white70),
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          12.sh,
                          TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText:
                                registerController.isShowPassword.value,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  registerController.changeShowPassword();
                                },
                                icon: Icon(
                                  registerController.isShowPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          12.sh,
                          Obx(() {
                            return TextFormField(
                              controller: confirmPasswordController,
                              style: const TextStyle(color: Colors.white),
                              obscureText:
                                  registerController.isShowCPassword.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    registerController.changeShowCPassword();
                                  },
                                  icon: Icon(
                                    registerController.isShowCPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                ),
                                hintText: 'Confirm Password',
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            );
                          }),
                          20.sh,
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  registerController.imageFile != null) {
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  String img = await ApiService.instance
                                      .sendUserImage(
                                          image: registerController.imageFile!);

                                  registerController.register(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    image: img,
                                  );
                                } else {
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  Get.snackbar('Failed',
                                      'Password and confirm password should be match');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          12.sh,
                          Center(
                            child: Text.rich(
                              TextSpan(
                                  text: 'Already have an account? ',
                                  style: const TextStyle(color: Colors.white70),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        },
                                      text: 'Login',
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
