import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:firebase_chat_app/ui/widgets/avatar_widgets.dart';
import 'package:flutter/material.dart';

class SearchedListItem extends StatelessWidget {
  const SearchedListItem({
    super.key,
    required this.model,
  });

  final ChatProvider model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      leading: const AvatarWidget(),
      title: Text(
        model.userMap?['name'] + ' ' + model.userMap?['lastName'],
        style: AppStyle.fontStyle.copyWith(
          fontSize: 15,
          color: AppColors.black,
        ),
      ),
      //       //Сделать проверку от кого последнее сообщение
      subtitle: Text(
        'Я готов',
        style: AppStyle.fontStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}
