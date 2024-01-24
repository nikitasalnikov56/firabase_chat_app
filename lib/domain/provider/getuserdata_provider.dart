import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class GetUserDataProvider extends ChangeNotifier {
  GetUserDataProvider() {
    if (_auth.currentUser != null) {
      getUserData();
    }
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String userName = '';
  String userLastName = '';
  String email = '';
  String nameFirstChar = '';
  String lastNameFirstChar = '';
  //получение данных пользователя
  Future getUserData() async {
    String? uid = _auth.currentUser?.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      userName = userDoc.get('name') ?? 'Нет имени';
      userLastName = userDoc.get('lastName') ?? 'Нет фамилии';
      email = userDoc.get('email') ?? 'Нет email';

      if (userName.isNotEmpty && userLastName.isNotEmpty) {
        nameFirstChar = userName[0];
        lastNameFirstChar = userLastName[0];
      }
      notifyListeners();
      return userName + userLastName + email;
    } else {
      throw FirebaseException(plugin: 'No such user data');
    }
  }

//добавление аватарки
  String image = '';

 
}
