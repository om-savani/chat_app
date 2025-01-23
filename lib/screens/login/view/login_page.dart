import 'dart:ui';

import 'package:chat_app/controller/login_controller.dart';
import 'package:chat_app/utils/extensions/sizedbox_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    LoginController loginController = Get.put(LoginController());
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  30.ph, // For the logo/icon
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.greenAccent,
                  ),
                  20.ph,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              8.pw,
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Account login',
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                          16.ph,
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
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
                          ),
                          12.ph,
                          //Password
                          TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: const Icon(Icons.remove_red_eye,
                                  color: Colors.white70),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          20.ph,
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                String email = emailController.text.trim();
                                String password =
                                    passwordController.text.trim();
                                loginController.login(
                                    email: email, password: password);
                              } else {
                                Get.snackbar(
                                    'Error', 'Please fill in all fields');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Log on',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          12.ph,
                          Center(
                            child: Text.rich(
                              TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: const TextStyle(color: Colors.white70),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(AppRoutes.register);
                                        },
                                      text: 'Sign up',
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
                  ),
                  20.ph,
                  const Text(
                    '- Social account login -',
                    style: TextStyle(color: Colors.white70),
                  ),
                  8.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtons(
                          icon: Icons.person,
                          onPress: () {
                            loginController.loginAnonymous();
                          }),
                      10.pw,
                      CustomButtons(
                        icon: Icons.facebook,
                        onPress: () {},
                      ),
                      10.pw,
                      CustomButtons(
                        icon: Icons.g_mobiledata,
                        onPress: () {
                          loginController.loginWithGoogle();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButtons extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;

  const CustomButtons({
    super.key,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes it circular
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1, // Border thickness
        ),
      ),
      child: IconButton(
        iconSize: 35,
        icon: Icon(icon),
        color: Colors.greenAccent, // Icon color
        onPressed: onPress,
        splashRadius: 28, // Customize splash radius
      ),
    );
  }
}
