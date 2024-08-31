import "package:cloud_firestore/cloud_firestore.dart";


class Message{
  final bool isSender;
  final String message;
  final Timestamp timestamp;

  Message(
      {
      required this.isSender,
      required this.message,
      required this.timestamp
      }
  );

  Map<String,dynamic> toMap(){
    return {
      "isSender":isSender,
      "message":message,
      "timestamp":timestamp,
    };
  }
}