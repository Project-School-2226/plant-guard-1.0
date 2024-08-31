import 'package:plant_guard/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(sender, message) async {
    try {
      Timestamp timestamp = Timestamp.now();
      Message newMessage =
          Message(isSender: sender, message: message, timestamp: timestamp);
      print("before await");
      await _firestore.collection("messages").add(newMessage.toMap());
      print("My message" + message);
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

  Future<int> getMessageCount() async {
  try {
    // Fetch the entire collection of messages
    QuerySnapshot querySnapshot = await _firestore.collection('messages').get();

    // Return the count of documents in the collection
    return querySnapshot.size;
  } catch (e) {
    print("Error getting message count: $e");
    return 0; // Return 0 if there's an error
  }
}

}
