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

  String _otherUserStatus = '';
  String get otherUserStatus => _otherUserStatus;

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

  Future<String?> getuserStatus(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc.get('status') : null;
  }

  Future<void> updateStatus(bool isOnline) async {
    await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      'status': isOnline ? 'online' : 'offline',
    });
  }

//добавление аватарки
  String image = '';
}
