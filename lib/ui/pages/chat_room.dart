import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';
import 'package:firebase_chat_app/domain/services/message_service.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key, this.userId, this.data});
  final String? userId;
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<GetUserDataProvider>();
    return Scaffold(
      appBar: AppBar(
        // leading: CircleAvatar(),
        title: ListTile(
          leading: CircleAvatar(),
          title: Text('${data?['name'] + ' ' + data?['lastName']}'),
          subtitle: Text('${data?['status']}'),
        ),
        centerTitle: true,
      ),
      body: ChatBody(
        userId: userId,
      ),
    );
  }
}

class ChatBody extends StatefulWidget {
  const ChatBody({super.key, required this.userId});
  final String? userId;
  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _messageService.sendMessage(
        widget.userId.toString(),
        messageController.text,
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //messages
        StreamBuilder(
          stream: _messageService.getMessages(
            widget.userId.toString(),
            _firebaseAuth.currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            return Expanded(
              child: ListView(
                children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document))
                    .toList(),
              ),
            );
          },
        ),
        //user input
        _buildMessageInput(),
      ],
    );
  }

  //build message list
  // Widget _buildMessageList() {
  //   return
  // }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //format timestamp
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    //message alignment
    var alignment = data['senderId'] == _firebaseAuth.currentUser?.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
    bool isSentMessage =
        data['senderId'] == _firebaseAuth.currentUser?.uid ? true : false;
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        color: isSentMessage ? AppColors.chatGreen : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            data['message'],
            style: AppStyle.fontStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGreen),
          ),
          const SizedBox(width: 15),
          Text(
            formattedDate,
            style: AppStyle.fontStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGreen),
          ),
        ],
      ),
    );
  }

  //input

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: SizedBox(
        height: 42,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {},
              label: const Icon(Icons.attach_file),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    fillColor: AppColors.lightGrey,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Сообщение',
                    hintStyle: AppStyle.fontStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
