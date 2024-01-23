import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/model/user_data.dart';
import 'package:firebase_chat_app/ui/pages/login_screen.dart';
import 'package:firebase_chat_app/ui/theme/app_colors.dart';
import 'package:firebase_chat_app/ui/theme/app_style.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  //firebase
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //for toggle screens
  bool showRegisterPage = true;

  //user data
  final _userData = UserData();
  UserData get userdata => _userData;

  //переключения между экранами
  void toggleScreens() {
    showRegisterPage = !showRegisterPage;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    final email = _userData.emailController.text.trim();
    final password = _userData.passwordController.text.trim();
    if (passwordConfirmed() && email != '' && password != '') {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (value) => addUserDetails(
              firstName: _userData.nameController.text.trim(),
              email: email,
            ),
          )
          .then((value) => controllersClear());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Поля не заполнены',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle.copyWith(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ),
      );
    }
  }

  //проверка совпадения паролей
  bool passwordConfirmed() {
    if (_userData.passwordController.text.trim() ==
        _userData.confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  //add user
  Future addUserDetails({
    String firstName = '',
    String email = '',
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .set({
      'first_name': capitalize(firstName),
      'email': email,
    });
  }

  //capitalize Name
  capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  // очистка контроллеров
  controllersClear() {
    _userData.nameController.clear();
    _userData.emailController.clear();
    _userData.passwordController.clear();
    _userData.confirmPasswordController.clear();
  }

  Future signIn(BuildContext context) async {
    try {
    
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _userData.emailController.text.trim(),
        password: _userData.passwordController.text.trim(),
      );
      // Успешная аутентификация
      User? user = userCredential.user;
    } catch (_) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Пользователя с почтой ${_userData.emailController.text.trim()} не существует',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle.copyWith(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
