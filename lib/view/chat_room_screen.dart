import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/conversation_screen.dart';
import 'package:chat_app/view/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;
  getUserInfo() async {
    StringConstant.myName =
        await HelperFunctions.getUserNameSharedPreferences() ?? '';
    await databaseMethods.getChatRooms(StringConstant.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  Widget chatRoomTile(String userName, chatRoomId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId, userName: userName),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Text(
                      userName.substring(0, 1).toUpperCase(),
                      style: simpleTextFieldStyle(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    userName,
                    style: simpleTextFieldStyle(
                        color: Colors.black, boldEnabled: true),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return chatRoomTile(
                        snapshot.data.docs[index]
                            .data()['chatRoomId']
                            .toString()
                            .replaceAll(StringConstant.myName, '')
                            .replaceAll('_', ''),
                        snapshot.data.docs[index].data()['chatRoomId']);
                  },
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, showSignOut: true),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
