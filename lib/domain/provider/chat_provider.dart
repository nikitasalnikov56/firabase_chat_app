import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/model/message.dart';
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

  //for toggle screens
  bool showRegisterPage = true;

  //для bottomnavbar
  int indexItem = 0;

  List<List<Color>> colorPairs = [
    [AppColors.gradientBlue1, AppColors.gradientBlue2],
    [AppColors.gradientGreen1, AppColors.gradientGreen2],
    [AppColors.gradientOrange1, AppColors.gradientOrange2],
  ];
  List<Color>? gradientColors;
  //функция выбора случайной пары цветов
  List<Color> chooseRandomColorPair() {
    int userIdAsNumber =
        auth.currentUser!.uid.codeUnits.reduce((a, b) => a + b);
    int randomIndex = userIdAsNumber % colorPairs.length;
    // Random().nextInt(colorPairs.length);
    return colorPairs[randomIndex];
  }

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
      User? user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (passwordConfirmed() &&
          email != '' &&
          password != '' &&
          user != null) {
        user.updateDisplayName(name);

        DateTime currentTime = DateTime.now();
        indexItem = 0;
        await firestore.collection('users').doc(auth.currentUser?.uid).set({
          'name': capitalize(name),
          'lastName': capitalize(lastName),
          'email': email.toLowerCase(),
          'status': 'Unavalible',
          'uid': auth.currentUser?.uid,
          'lastOnline': currentTime,
        }).then((value) => controllersClear());
        gradientColors = chooseRandomColorPair();
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

  //проверка совпадения паролей
  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
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

  QuerySnapshot<Map<String, dynamic>>? userSnapshot;

//список юзеров
  Future<List<Map<String, dynamic>>?> getAllUsers() async {
    User? currentuser = auth.currentUser;
    String currentUserId = currentuser?.uid ?? '';
    try {
      userSnapshot = await firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUserId)
          .get();

      List<Map<String, dynamic>> usersList = userSnapshot!.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data()!)
          .toList();
  
      return usersList;
    } catch (e) {
      return null;
    }
  }

  //поиск юзеров
  Map<String, dynamic>? userMap;

  Future<void> onSearch() async {
    if (searchController.text.isEmpty) {
      getAllUsers();
    }
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















  // await _auth
  //     .createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     )
  //     .then(
  //       (value) => addUserDetails(
  //         firstName: nameController.text.trim(),
  //         lastName: lastNameController.text.trim(),
  //         email: email.toLowerCase(),

  //       ),
  //     )
  //     .then((value) => controllersClear());
  
  
  
  
  
  
  
  //добавление пользователя
  // Future addUserDetails({
  //   String firstName = '',
  //   String lastName = '',
  //   String email = '',
  // }) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_auth.currentUser?.uid)
  //       .set(
  //     {
  //       'first_name': capitalize(firstName),
  //       'last_name': capitalize(lastName),
  //       'email': email,
  //     },
  //   );
  // }