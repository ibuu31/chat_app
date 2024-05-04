import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth.dart';
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
    Constant.myName =
        await HelperFunctions.getUserNameSharedPreferences() ?? '';
    await databaseMethods.getChatRooms(Constant.myName).then((value) {
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
              builder: (context) => ConversationScreen(chatRoomId: chatRoomId),
            ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                '${userName.substring(0, 1).toUpperCase()}',
                style: simpleTextFieldStyle(),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: simpleTextFieldStyle(),
            ),
          ],
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
                            .replaceAll(Constant.myName, '')
                            .replaceAll('_', ''),
                        snapshot.data.docs[index].data()['chatRoomId']);
                  },
                )
              : Container();
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
                builder: (context) => SearchScreen(),
              ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
