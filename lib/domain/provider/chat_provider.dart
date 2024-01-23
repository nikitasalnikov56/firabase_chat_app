import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/theme/app_colors.dart';
import 'package:firebase_chat_app/ui/theme/app_style.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  //firebase
  final _auth = FirebaseAuth.instance;

  //controllers
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //for toggle screens
  bool showRegisterPage = true;

  
  //переключения между экранами
  void toggleScreens() {
    showRegisterPage = !showRegisterPage;
    notifyListeners();
  }

//регистрация
  Future<void> signUp(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (passwordConfirmed() && email != '' && password != '') {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (value) => addUserDetails(
              firstName: nameController.text.trim(),
              lastName: lastNameController.text.trim(),
              email: email.toLowerCase(),
              
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
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  //добавление пользователя
  Future addUserDetails({
    String firstName = '',
    String lastName = '',
    String email = '',
 
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .set(
      {
        'first_name': capitalize(firstName),
        'last_name': capitalize(lastName),
        'email': email,
        
      },
    );
  }

  //capitalize Name
  capitalize(String str) =>
      str[0].toUpperCase() + str.substring(1).toLowerCase();

  // очистка контроллеров
  controllersClear() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  //авторизация с проверкой по емайл
  Future signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Успешная аутентификация
      User? user = userCredential.user;
    } catch (_) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Пользователя с почтой ${emailController.text.trim()} не существует',
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

  //переключение экранов
  int indexItem = 0;
  navbarScreenToggle(int index) {
    indexItem = index;
    notifyListeners();
  }
}
