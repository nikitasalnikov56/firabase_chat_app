import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/model/message.dart';

class MessageService {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create new message

    Message newMessage = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      senderEmail: currentUserEmail,
      content: message,
      timestamp: timestamp,
    );

    /// construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort the ids (this ensures chat room id is alsways the same for any pair of people)

    String chatRoomId = ids.join(
        '_'); // combine the ids into a single string to use as a chatroomID

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get messege
  Stream<QuerySnapshot> getMessages(String userId, String otheUserId) {
    //construct chat room id from user ids(sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otheUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Stream<List<Message>> getMessages(String userId) {
  //   return _firestore
  //       .collection('messages')
  //       .where('receiverId', isEqualTo: userId)
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data();
  //       return Message(
  //         senderId: data['senderId'],
  //         receiverId: data['receiverId'],
  //         content: data['content'],
  //         timestamp: (data['timestamp'] as Timestamp).toDate(),
  //       );
  //     }).toList();
  //   });
  // }
}
