import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/pages/chat_room.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:firebase_chat_app/ui/widgets/avatar_widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return _buildUserList(model);
  }

  //users except current user
  Widget _buildUserList(ChatProvider model) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading...'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc, context, model))
              .toList(),
        );
      },
    );
  }

  //список пользовтаелей
  Widget _buildUserListItem(
      DocumentSnapshot document, BuildContext context, ChatProvider model) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (FirebaseAuth.instance.currentUser?.email != data['email']) {
      Timestamp lastOnlineTimestamp = data['lastOnline'];
      DateTime lastOnline = lastOnlineTimestamp.toDate();

      String formattedTime = model.formatTime(lastOnline);
      return ListTile(
        leading: AvatarWidget(
          user: data,
        ),
        title: Text(data['name'] + ' ' + data['lastName']),
        subtitle: const Text('Message'),
        trailing: Text(
          formattedTime,
          style: AppStyle.fontStyle.copyWith(
            color: AppColors.darkGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(
                data: data,
                userId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
