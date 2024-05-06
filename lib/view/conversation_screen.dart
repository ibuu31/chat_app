import 'dart:developer';

import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, this.chatRoomId, this.userName})
      : super(key: key);
  final String? chatRoomId;
  final String? userName;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream? chatMessageStream;
  sendMessage() {
    Map<String, dynamic> messageMap = {
      'message': messageController.text,
      'sendBy': StringConstant.myName,
      'time': DateTime.now().millisecondsSinceEpoch
    };
    if (messageController.text.isNotEmpty) {
      log(widget.chatRoomId.toString());
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
    messageController.clear();
  }

  Widget messageTile(String message, bool isSendByMe) {
    return Container(
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      child: Container(
        margin: isSendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: isSendByMe
              ? Theme.of(context).primaryColor
              : Colors.grey.shade600,
          // gradient: LinearGradient(
          //   colors: isSendByMe
          //       ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
          //       : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          // ),
        ),
        child: Text(
          message,
          style: simpleTextFieldStyle(),
        ),
      ),
    );
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return messageTile(
                        snapshot.data.docs[index].data()['message'],
                        snapshot.data.docs[index].data()['sendBy'] ==
                            StringConstant.myName);
                  },
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    super.initState();

    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(40)),
              child: Image.network(
                  'https://e7.pngegg.com/pngimages/753/432/png-clipart-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-thumbnail.png'),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.userName ?? '',
              style: simpleTextFieldStyle(),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: chatMessageList()),
                const SizedBox(
                  height: 90,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: simpleTextFieldStyle(),
                      controller: messageController,
                      decoration: textFieldInputDecoration('Message...',
                          isUnderLineBorder: true),
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          color: Colors.white,
                          icon: const Icon(
                            Icons.send,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
