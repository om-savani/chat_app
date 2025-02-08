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
                  30.sh,
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.greenAccent,
                  ),
                  20.sh,
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
                              8.sw,
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Account login',
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                          16.sh,
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
                          12.sh,
                          //Password
                          Obx(() {
                            return TextFormField(
                              controller: passwordController,
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              obscureText: loginController.isShowPassword.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    loginController.changeShowPassword();
                                  },
                                  icon: Icon(
                                    loginController.isShowPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            );
                          }),
                          20.sh,
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
                          12.sh,
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
                  20.sh,
                  const Text(
                    '- Social account login -',
                    style: TextStyle(color: Colors.white70),
                  ),
                  8.sh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtons(
                          icon: Icons.person,
                          onPress: () {
                            loginController.loginAnonymous();
                          }),
                      10.sw,
                      CustomButtons(
                        icon: Icons.facebook,
                        onPress: () {},
                      ),
                      10.sw,
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
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: IconButton(
        iconSize: 35,
        icon: Icon(icon),
        color: Colors.greenAccent,
        onPressed: onPress,
        splashRadius: 28,
      ),
    );
  }
}
