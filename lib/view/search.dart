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
    print(Constant.myName);
    if (username != Constant.myName) {
      String chatRoomId = getChatRoomId(username, Constant.myName);
      List<String> users = [username, Constant.myName];
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
                  )));
    }
  }

  Widget searchTile({username, userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: simpleTextFieldStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextFieldStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomForConversation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(
                'Message',
                style: simpleTextFieldStyle(),
              ),
            ),
          ),
        ],
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
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    decoration: textFieldInputDecoration('search username...'),
                  )),
                  GestureDetector(
                    onTap: () {
                      databaseMethods
                          .getUserByUsername(searchController.text)
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          print('object is not empty');
                        } else {
                          print('object is empty');
                        }
                        for (DocumentSnapshot doc in value.docs) {
                          listLength = value.docs.length;
                          print('$listLength printed');
                          username =
                              (doc.data() as Map<String, dynamic>)['username'];
                          userEmail =
                              (doc.data() as Map<String, dynamic>)['email'];
                          print('Document ID: ${doc.id}');
                          print(
                              'Document Data: ${(doc.data() as Map<String, dynamic>)['username']}');
                        }
                        setState(() {});
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ])),
                      child: Image.asset(
                        'assets/images/search_white.png',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: searchList()),
          ],
        ),
      ),
    );
  }
}
