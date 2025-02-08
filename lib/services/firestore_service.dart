import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';

class FireStoreService {
  FireStoreService._();
  static FireStoreService instance = FireStoreService._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //user collection
  String userCollection = 'users';

  // Add a new user
  Future<void> addUser({required UserModel user}) async {
    await fireStore.collection(userCollection).doc(user.email).set(user.toMap);
  }

  //get users
  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    String currentUser =
        FirebaseServices.firebaseServices.auth.currentUser!.email ?? '';
    return fireStore
        .collection(userCollection)
        .where('email', isNotEqualTo: currentUser)
        .snapshots();
  }

  //get single user
  Future<DocumentSnapshot<Map<String, dynamic>>> getSingleUser() async {
    String currentUser =
        FirebaseServices.firebaseServices.auth.currentUser!.email ?? '';
    return await fireStore.collection(userCollection).doc(currentUser).get();
  }

  //chats
  String chatRoomCollection = 'chatCollection';
  //chats method
  String createDocId({
    required String sender,
    required String receiver,
  }) {
    List users = [sender, receiver];

    users.sort();

    String docId = users.join('&');

    return docId;
  }

  //sent chat
  void sentChat({required ChatModel chatModal}) {
    String docId =
        createDocId(sender: chatModal.sender, receiver: chatModal.receiver);

    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .add(chatModal.toMap);
  }

  //get chats
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats({
    required String sender,
    required String receiver,
  }) {
    String docId = createDocId(sender: sender, receiver: receiver);

    return fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  //delete chat
  void deleteChat(
      {required String sender, required String receiver, required String id}) {
    String docId = createDocId(sender: sender, receiver: receiver);
    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .delete();
  }

  //edit chat
  void editChat(
      {required String sender,
      required String receiver,
      required String id,
      required String message}) {
    String docId = createDocId(sender: sender, receiver: receiver);
    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .update({'message': message});
  }

  Future<void> updateMessageSeenStatus({
    required String sender,
    required String receiver,
    required String id,
  }) async {
    String docId = createDocId(sender: sender, receiver: receiver);
    await fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .update({'seen': true});
  }
}
