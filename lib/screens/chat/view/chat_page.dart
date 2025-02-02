import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chat_model.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserModel data = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(data.name),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreService.instance.getChats(
                  sender: FirebaseServices
                          .firebaseServices.auth.currentUser!.email ??
                      '',
                  receiver: data.email,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var chatData = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChats =
                        chatData!.docs;
                    List<ChatModel> allChatData = allChats
                        .map((e) => ChatModel.fromMap(map: e.data()))
                        .toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: allChatData.length,
                      itemBuilder: (context, index) {
                        bool isSentByMe = allChatData[index].sender ==
                            FirebaseServices
                                .firebaseServices.auth.currentUser!.email;
                        return ChatBox(
                            chat: allChatData[index],
                            user: data,
                            isSender: isSentByMe);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            messageInputField(data),
          ],
        ),
      ),
    );
  }

  Widget messageInputField(
    UserModel user,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.greenAccent),
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                FireStoreService.instance.sentChat(
                  chatModal: ChatModel(
                    message: messageController.text.trim(),
                    receiver: user.email,
                    sender: FirebaseServices
                            .firebaseServices.auth.currentUser!.email ??
                        '',
                    time: Timestamp.now(),
                  ),
                );
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final ChatModel chat;
  final UserModel user;
  final bool isSender;

  const ChatBox(
      {required this.chat,
      required this.user,
      required this.isSender,
      super.key});
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    } else if (date.day == now.day - 1 &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(formatDate(chat.time),
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isSender ? Colors.blueAccent : Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSender ? 16 : 0),
                topRight: Radius.circular(isSender ? 0 : 16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chat.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      chat.message,
                      style: TextStyle(
                          color: isSender ? Colors.white : Colors.black),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('hh:mm a').format(chat.time.toDate()),
                    style: TextStyle(
                        fontSize: 10,
                        color: isSender ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
