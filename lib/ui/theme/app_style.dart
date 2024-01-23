import 'package:firebase_chat_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppStyle {
  static TextStyle fontStyle =  TextStyle(
    fontSize: 32,
    fontFamily: 'Gilroy',
    color: AppColors.blackGrey,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );
}
