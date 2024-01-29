import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/services/auth_service.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatProvider extends ChangeNotifier {
  //firebase
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  //controllers
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final searchController = TextEditingController();
  final messageController = TextEditingController();

  //services
  final _authService = AuthService();

  //for toggle screens
  bool showRegisterPage = true;

  //для bottomnavbar
  int indexItem = 0;

  //time 
  DateTime currentTime = DateTime.now();
  //переключения между экранами
  void toggleScreens() {
    showRegisterPage = !showRegisterPage;
    notifyListeners();
  }

//регистрация
  Future<User?> signUp(
    BuildContext context, {
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      User? user = (await _authService.signUpWithEmailandPassword(
              email.toLowerCase(), password.toLowerCase()))
          .user;
      if (_authService.passwordConfirmed(
              passwordController.text.trim().toLowerCase(),
              confirmPasswordController.text.trim().toLowerCase()) &&
          email != '' &&
          password != '' &&
          user != null) {
        user.updateDisplayName(name);

        
        indexItem = 0;
        await firestore.collection('users').doc(user.uid).set({
          'name': capitalize(name),
          'lastName': capitalize(lastName),
          'email': email.toLowerCase(),
          'status': 'offline',
          'uid': user.uid,
          'lastOnline': currentTime,
        }, SetOptions(merge: true)).then((value) => controllersClear());

        return user;
      } else {
        // ignore: use_build_context_synchronously
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
        return user;
      }
    } catch (e) {
      return null;
    }
  }

  //capitalize
  capitalize(String str) =>
      str[0].toUpperCase() + str.substring(1).toLowerCase();

  // очистка контроллеров
  controllersClear() {
    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  //авторизация с проверкой по емайл
  Future signIn(BuildContext context) async {
    navbarScreenToggle(0);
    try {
      UserCredential userCredential =
          await _authService.signInWithEmailandPassword(
        emailController.text.trim().toLowerCase(),
        passwordController.text.trim().toLowerCase(),
      );
      // Успешная аутентификация
      User? user = userCredential.user;
  
      controllersClear();
      return user;
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

  navbarScreenToggle(int index) {
    indexItem = index;
    notifyListeners();
  }

  //поиск юзеров
  Map<String, dynamic>? userMap;

  Future<void> onSearch() async {
    await firestore
        .collection('users')
        .where('name', isEqualTo: searchController.text)
        .get()
        .then((value) {
      userMap = value.docs[0].data();
      notifyListeners();
    });
  }

//форматирование
  String formatTime(DateTime time) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(time);

    if (difference.inDays == 0) {
      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes == 1) {
        return '1 minute ago';
      } else if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('HH:mm').format(time);
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }
}















  
  
  
  
  
