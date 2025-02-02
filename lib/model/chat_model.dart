import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String sender;
  String receiver;
  String message;
  Timestamp time;

  ChatModel(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.time});

  factory ChatModel.fromMap({required Map<String, dynamic> map}) => ChatModel(
        sender: map['sender'] ?? '',
        receiver: map['receiver'] ?? '',
        message: map['message'] ?? '',
        time: map['time'] ?? Timestamp.now(),
      );

  Map<String, dynamic> get toMap => {
        'sender': sender,
        'receiver': receiver,
        'message': message,
        'time': time,
      };
}
