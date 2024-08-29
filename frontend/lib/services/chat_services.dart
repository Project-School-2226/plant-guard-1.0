import 'package:plant_guard/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(sender,message) async {
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(isSender: sender,message: message,timestamp: timestamp);
    try {
      await _firestore.collection("messages").add(newMessage.toMap());
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Message>> getMessages() {
    return _firestore
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message(
          isSender: doc["isSender"],
          message: doc["message"],
          timestamp: doc["timestamp"],
        );
      }).toList();
    });
  }
}
