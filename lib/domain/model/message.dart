import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String content;
  String senderEmail;
  Timestamp timestamp;
  bool isRead;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.senderEmail,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': content,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}
