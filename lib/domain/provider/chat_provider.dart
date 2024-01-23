import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool showRegisterPage = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //переключения между экранами
  void toggleScreens() {
    showRegisterPage = !showRegisterPage;
    notifyListeners();
  }
}
