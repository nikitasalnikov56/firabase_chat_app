// import 'package:firebase_chat_app/domain/model/message.dart';
// import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/model/message.dart';
import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/domain/services/message_service.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// class ChatRoom extends StatelessWidget {
//   const ChatRoom({super.key, this.userName, this.userId});
//   final String? userName;
//   final String? userId;
//   @override
//   Widget build(BuildContext context) {
//     final model = context.watch<ChatProvider>();
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat With $userName'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder(
//                 stream: model.getMessages(userId ?? ''),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     List<Message> messages = snapshot.data!;
//                     return ListView.builder(
//                       itemBuilder: (context, i) {
//                         Message message = messages[i];
//                         return ListTile(
//                           title: Text(
//                             message.content,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           subtitle: Text(
//                             message.timestamp.toString(),
//                             style: TextStyle(
//                               color: AppColors.chatGreen,
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: messages.length,
//                     );
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: model.messageController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Type message...',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       model.btnTapSendMessage(userId);
//                     },
//                     icon: const Icon(
//                       Icons.send,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Expanded(
//             //   child: StreamBuilder<QuerySnapshot>(
//             //     stream: model.firestore
//             //         .collection('chatroom')
//             //         .doc(model.chatRoomId(
//             //           '${model.auth.currentUser?.displayName}',
//             //           model.userMap?['name'],
//             //         ))
//             //         .collection('chats')
//             //         .orderBy('time', descending: false)
//             //         .snapshots(),
//             //     builder: (context, snapshot) {
//             //       if (snapshot.data != null) {
//             //         return Container(
//             //           color: Colors.red,
//             //         );
//             //         // ListView.builder(
//             //         //   itemBuilder: (context, i) {
//             //         //     Map<String, dynamic> map = snapshot.data?.docs[i].data()
//             //         //         as Map<String, dynamic>;
//             //         //     return message(size, map, model);
//             //         //   },
//             //         //   itemCount: snapshot.data?.docs.length,
//             //         // );
//             //       } else {
//             //         return const SizedBox();
//             //       }
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget message(Size size, Map<String, dynamic> map, ChatProvider model) {
//     return map['type'] == 'text'
//         ? Container(
//             width: size.width,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             alignment: map['name'] == model.auth.currentUser?.displayName
//                 ? Alignment.centerRight
//                 : Alignment.centerLeft,
//             child: map['name'] == model.auth.currentUser?.displayName
//                 ? Container(
//                     padding: const EdgeInsets.only(
//                       top: 8,
//                       left: 16,
//                       bottom: 8,
//                       right: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.chatGreen,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                         bottomLeft: Radius.circular(16),
//                       ),
//                     ),
//                     child: Text(
//                       map['message'],
//                       style: AppStyle.fontStyle.copyWith(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.darkGreen,
//                       ),
//                     ),
//                   )
//                 : Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: AppColors.lightGrey,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                         bottomRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: Text(
//                       map['message'],
//                       style: AppStyle.fontStyle.copyWith(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.blackGrey,
//                       ),
//                     ),
//                   ),
//           )
//         : Container(
//             alignment: map['name'] == model.auth.currentUser?.displayName
//                 ? Alignment.centerRight
//                 : Alignment.centerLeft,
//             margin: const EdgeInsets.symmetric(
//               horizontal: 8,
//               vertical: 16,
//             ),
//             child: Container(
//               width: 200,
//               height: 200,
//               color: AppColors.black,
//               child: map['message'] != ''
//                   ? Image.network(
//                       map['message'],
//                       fit: BoxFit.cover,
//                     )
//                   : const CircularProgressIndicator(),
//             ),
//           );
//   }
// }
import 'dart:async';

class ChatRoom extends StatefulWidget {
  final String? userId;
  final String? userName;

  const ChatRoom({super.key, this.userId, this.userName});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  MessageService messageService = MessageService();
  StreamController<List<Message>> messageStreamController =
      StreamController<List<Message>>();

  @override
  void initState() {
    super.initState();
    _setupMessagesStream();
  }

  void _setupMessagesStream() {
    messageService.getMessages(widget.userId ?? '').listen((messages) {
      messageStreamController.add(messages);
    });
  }

  @override
  void dispose() {
    messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userName}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Message> messages =
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Message(
                    senderId: data['senderId'],
                    receiverId: data['receiverId'],
                    content: data['content'],
                    timestamp: (data['timestamp'] as Timestamp).toDate(),
                  );
                }).toList();
                return ListView.separated(
                  reverse: true,
                  separatorBuilder: (context, i) => const SizedBox(height: 20),
                  itemBuilder: (context, i) {
                    bool isSentMessage =
                        messages[i].senderId == model.auth.currentUser?.uid;

                    return Align(
                      alignment: isSentMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 290),
                        child: Card(
                          color: isSentMessage
                              ? AppColors.chatGreen
                              : AppColors.lightGrey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messages[i].content),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    DateFormat('HH:mm')
                                        .format(messages[i].timestamp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: messages.length,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    btnTapSendMessage(model.auth.currentUser?.uid, model.auth);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void btnTapSendMessage(String? id, FirebaseAuth auth) {
    if (messageController.text.isNotEmpty) {
      Message message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: id ?? '',
        content: messageController.text,
        timestamp: DateTime.now(),
        isRead: false,
      );
      messageService.sendMessage(message);
     
      messageController.clear();
    } else {
      print('No user');
    }
  }
}
