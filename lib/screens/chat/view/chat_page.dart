import 'dart:io';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/fcm_service.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/extensions/sizedbox_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  TextEditingController editController = TextEditingController();
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    UserModel data = Get.arguments;
    String currentUser =
        FirebaseServices.firebaseServices.auth.currentUser!.email ?? '';
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        chatController.closeEmojiPicker();
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(data.name),
          actions: [
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(20),
                  radius: 200,
                  title: "",
                  content: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(data.photoUrl),
                  ),
                );
              },
              child: CircleAvatar(
                foregroundImage: NetworkImage(data.photoUrl),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/background/chat_bg.jpg"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.05), BlendMode.darken),
            ),
            color: Colors.white,
            borderRadius: const BorderRadius.only(
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
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allChats = chatData!.docs;
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
                          return GestureDetector(
                            onLongPress: () {
                              editController.text = allChatData[index].message;
                              chatController.reset();
                              DateTime messageTime =
                                  allChatData[index].time.toDate();
                              DateTime now = DateTime.now();
                              chatController.checkEditable(messageTime, now);
                              Get.bottomSheet(
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        return Visibility(
                                          visible:
                                              chatController.isEdit.value ==
                                                  false,
                                          child: Text(
                                            allChatData[index].message,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }),
                                      Obx(() {
                                        return Visibility(
                                          visible:
                                              chatController.isEdit.value ==
                                                  true,
                                          child: TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  String msg =
                                                      editController.text;
                                                  if (msg.isNotEmpty) {
                                                    FireStoreService.instance
                                                        .editChat(
                                                      sender: currentUser,
                                                      receiver: data.email,
                                                      id: allChats[index].id,
                                                      message:
                                                          editController.text,
                                                    );
                                                  }
                                                  chatController.isEdit.value =
                                                      false;
                                                  Get.back();
                                                },
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: primaryColor,
                                                ),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                          ),
                                        );
                                      }),
                                      5.sh,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              FireStoreService.instance
                                                  .deleteChat(
                                                sender: currentUser,
                                                receiver: data.email,
                                                id: allChats[index].id,
                                              );
                                              Get.back();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Obx(() {
                                            return Visibility(
                                              visible: chatController
                                                      .isEditable.value &&
                                                  !isSentByMe,
                                              child: IconButton(
                                                onPressed: () {
                                                  chatController.changeEdit();
                                                },
                                                icon: Icon(
                                                  chatController.isEdit.value ==
                                                          true
                                                      ? Icons.done
                                                      : Icons.edit,
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ChatBox(
                                chat: allChatData[index],
                                user: data,
                                id: allChats[index].id,
                                isSender: isSentByMe),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              messageInputField(data, currentUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageInputField(UserModel user, String currentUser) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  focusNode: chatController.focusNode,
                  onTap: () =>
                      chatController.isEmojiPickerVisible.value = false,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: chatController.openEmojiPicker,
                      icon: Obx(
                        () => Icon(
                          chatController.isEmojiPickerVisible.value
                              ? Icons.keyboard
                              : Icons.emoji_emotions,
                        ),
                      ),
                    ),
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: primaryColor),
                onPressed: () {
                  if (messageController.text.trim().isNotEmpty) {
                    FireStoreService.instance.sentChat(
                      chatModal: ChatModel(
                        message: messageController.text.trim(),
                        receiver: user.email,
                        sender: currentUser,
                        seen: false,
                        time: Timestamp.now(),
                      ),
                    );
                    FCMService.instance.sendFCM(
                      title: currentUser,
                      body: messageController.text.trim(),
                      token: user.token,
                    );
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
        Obx(() {
          return chatController.isEmojiPickerVisible.value
              ? SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      messageController.text += emoji.emoji;
                    },
                  ),
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}

class ChatBox extends StatelessWidget {
  final ChatModel chat;
  final UserModel user;
  final String id;
  final bool isSender;

  const ChatBox({
    required this.chat,
    required this.user,
    required this.isSender,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSender && !chat.seen) {
      FireStoreService.instance.updateMessageSeenStatus(
        sender: chat.sender,
        receiver: chat.receiver,
        id: id,
      );
    }

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            formatDate(chat.time),
            style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold),
          ),
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
              color: isSender ? primaryColor : Colors.grey.shade300,
              border: isSender
                  ? Border.all(color: const Color(0xFF006B49), width: 1.5)
                  : Border.all(color: Colors.grey, width: 1.5),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(chat.time.toDate()),
                      style: TextStyle(
                        fontSize: 10,
                        color: isSender ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    if (isSender) ...[
                      const SizedBox(width: 5),
                      Icon(
                        chat.seen ? Icons.done_all : Icons.check,
                        size: 16,
                        color: chat.seen ? Colors.blue : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
}
