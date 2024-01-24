import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/domain/model/message.dart';

class MessageService {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'content': message.content,
      'timestamp': message.timestamp,
    });
  }

  Stream<List<Message>> getMessages(String userId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Message(
          senderId: data['senderId'],
          receiverId: data['receiverId'],
          content: data['content'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }


}
