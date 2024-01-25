class Message {
  String senderId;
  String receiverId;
  String content;
  DateTime timestamp;
  bool isRead;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
     this.isRead = false,
  });
}
