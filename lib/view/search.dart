import 'dart:developer';

import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  String username = '';
  String userEmail = '';
  int listLength = 0;
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  createChatRoomForConversation(String username) {
    log(StringConstant.myName);
    if (username != StringConstant.myName) {
      String chatRoomId = getChatRoomId(username, StringConstant.myName);
      List<String> users = [username, StringConstant.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      databaseMethods.createChatRoom(
          chatRoomId: chatRoomId, chatRoomMap: chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    userName: username,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You can't have conversation with self."),
      ));
    }
  }

  Widget searchTile({username, userEmail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: simpleTextFieldStyle(color: Colors.black),
                ),
                Text(
                  userEmail,
                  style: simpleTextFieldStyle(color: Colors.black),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  createChatRoomForConversation(username);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))),
                child: const Text('Message')),
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    return ListView.builder(
      itemCount: listLength,
      itemBuilder: (context, index) {
        return searchTile(username: username, userEmail: userEmail);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration(
                            'search username...',
                            searchField: true),
                      ),
                    )),
                    Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: IconButton(
                            onPressed: () {
                              databaseMethods
                                  .getUserByUsername(searchController.text)
                                  .then((value) {
                                if (value.docs.isNotEmpty) {
                                  log('object is not empty');
                                } else {
                                  log('object is empty');
                                }
                                for (DocumentSnapshot doc in value.docs) {
                                  listLength = value.docs.length;
                                  log('$listLength printed');
                                  username = (doc.data()
                                      as Map<String, dynamic>)['username'];
                                  userEmail = (doc.data()
                                      as Map<String, dynamic>)['email'];
                                  log('Document ID: ${doc.id}');
                                  log('Document Data: ${(doc.data() as Map<String, dynamic>)['username']}');
                                }
                                setState(() {});
                              });
                            },
                            color: Colors.white,
                            icon: const Icon(Icons.search))),
                  ],
                ),
              ),
            ),
            Expanded(child: searchList()),
          ],
        ),
      ),
    );
  }
}
