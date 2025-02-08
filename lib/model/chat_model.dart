import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String sender;
  String receiver;
  String message;
  bool seen;
  Timestamp time;

  ChatModel(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.seen,
      required this.time});

  factory ChatModel.fromMap({required Map<String, dynamic> map}) => ChatModel(
        sender: map['sender'] ?? '',
        receiver: map['receiver'] ?? '',
        message: map['message'] ?? '',
        seen: (map['seen'] is bool) ? map['seen'] : false,
        time: map['time'] ?? Timestamp.now(),
      );

  Map<String, dynamic> get toMap => {
        'sender': sender,
        'receiver': receiver,
        'message': message,
        'seen': seen,
        'time': time,
      };
}
