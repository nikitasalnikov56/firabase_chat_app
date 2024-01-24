import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:firebase_chat_app/ui/widgets/avatar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  Widget buildUserListWidget(
      List<Map<String, dynamic>> users, ChatProvider model) {
    return ListView.separated(
      itemBuilder: (context, i) {
        Map<String, dynamic> user = users[i];
        Timestamp lastOnlineTimestamp = user['lastOnline'];
        DateTime lastOnline = lastOnlineTimestamp.toDate();

        String formattedTime = model.formatTime(lastOnline);

        return ListTile(
          titleAlignment: ListTileTitleAlignment.top,
          leading: const AvatarWidget(),
          title: Text(
            user['name'] + ' ' + user['lastName'],
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
          //время сообщения
          trailing: Text(
            formattedTime,
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darkGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
      separatorBuilder: (context, i) => Divider(
        color: AppColors.grey,
        indent: 20,
        endIndent: 20,
      ),
      itemCount: users.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return FutureBuilder<List<Map<String, dynamic>>?>(
        future: model.getAllUsers(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Users found'),
            );
          } else {
            return buildUserListWidget(snapshot.data!, model);
          }
        });
  }
}
