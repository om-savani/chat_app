import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/utils/extensions/sizedbox_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/firebase_services.dart';
import '../../../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.greenAccent,
      drawer: Drawer(
        child: Column(
          children: [
            FutureBuilder(
              future: FireStoreService.instance.getSingleUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("ERROR : ${snapshot.error}");
                } else if (snapshot.hasData) {
                  var data = snapshot.data;

                  UserModel modal = UserModel.fromMap(data?.data() ?? {});
                  userName = modal.name;

                  return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      foregroundImage: NetworkImage(modal.photoUrl ??
                          'https://avatars.mds.yandex.net/i?id=d36ac640ce13876899fd2633f75ec08f0cb05b5b-9226569-images-thumbs&ref=rim&n=33&w=250&h=250'),
                    ),
                    accountName: Text(modal.name ?? 'Unknown'),
                    accountEmail: Text(modal.email ?? 'Unknown'),
                  );
                }

                return Container();
              },
            ),
            ListTile(
              onTap: () {
                FirebaseServices.firebaseServices.logout();
                Get.offNamed(AppRoutes.login);
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Log Out"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text.rich(TextSpan(
          text: 'Hello, ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            // fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.more_horiz_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Row(
          //   children: [
          //
          //     const Spacer(),
          //
          //   ],
          // ),
          20.sh,
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: StreamBuilder(
                stream: FireStoreService.instance.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var data = snapshot.data;

                    List<QueryDocumentSnapshot<Map<String, dynamic>>>? allDocs =
                        data?.docs ?? [];
                    List<UserModel> userData = allDocs
                        .map(
                          (e) => UserModel.fromMap(e.data()),
                        )
                        .toList();

                    return ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        var usersInfo = userData[index];

                        return ListTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.chat, arguments: usersInfo);
                          },
                          leading: CircleAvatar(
                            foregroundImage:
                                NetworkImage(usersInfo.photoUrl ?? ''),
                          ),
                          title: Text(usersInfo.name),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
