import 'package:chat_app/screens/login/view/login_page.dart';
import 'package:chat_app/screens/register/view/register_page.dart';
import 'package:get/get.dart';

import '../screens/chat/view/chat_page.dart';
import '../screens/home/view/home_page.dart';
import '../screens/splash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String chat = '/chat';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: chat, page: () => const ChatPage()),
  ];
}
