import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.user,
  });
  final Map<String, dynamic>? user;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<GetUserDataProvider>();
    
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientOrange1,
            AppColors.gradientOrange2,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: model.image.isEmpty
          ? Text(
              '${user?['name'][0]}${user?['lastName'][0]}',
              style: AppStyle.fontStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            )
          : null,
    );
  }
}
