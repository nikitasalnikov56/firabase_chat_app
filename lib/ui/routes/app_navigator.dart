import 'package:firebase_chat_app/ui/pages/main_screen.dart';
import 'package:firebase_chat_app/ui/pages/login_screen.dart';
import 'package:firebase_chat_app/ui/pages/register_screen.dart';
import 'package:firebase_chat_app/ui/pages/start_screen.dart';
import 'package:firebase_chat_app/ui/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

abstract class AppNavigator {
  static final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.startScreen,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainScreen,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
