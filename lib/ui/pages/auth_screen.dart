import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/pages/login_screen.dart';
import 'package:firebase_chat_app/ui/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthBody(),
    );
  }
}

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    if (model.showRegisterPage) {
      return RegisterScreen(showLoginPage: model.toggleScreens);
    } else {
      return LoginScreen(showRegisterPage: model.toggleScreens);
    }
  }
}
