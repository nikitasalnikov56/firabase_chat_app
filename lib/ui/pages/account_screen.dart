import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/services/auth_service.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountWidget();
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    super.key,
  });
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static String? status;
  getStatus() async {
    final userDoc =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    status = userDoc.get('status');
  }

  @override
  Widget build(BuildContext context) {
    getStatus();
    final model = context.watch<GetUserDataProvider>();

    final authService = AuthService();
    return Container(
      color: AppColors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                authService.logOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientBlue1,
                  AppColors.gradientBlue2,
                ],
              ),
            ),
            child: model.image.isEmpty
                ? Text(
                    '${model.nameFirstChar}${model.lastNameFirstChar}',
                    style: AppStyle.fontStyle,
                  )
                : Image.asset('name'),
          ),
          const SizedBox(height: 20),
          Text(status.toString()),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: AppColors.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${model.userName}\t ${model.userLastName}',
                  style: AppStyle.fontStyle
                      .copyWith(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: AppColors.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.email,
                  style: AppStyle.fontStyle
                      .copyWith(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
