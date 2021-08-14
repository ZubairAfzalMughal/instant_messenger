import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

final fireStore = FirebaseFirestore.instance;
User? userLogged;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  String? message;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      if (_auth != null) {
        var user = _auth.currentUser;
        userLogged = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBubble(), //For Displating Messages
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        fireStore.collection('messages').add({
                          'sender': userLogged!.email,
                          'text': message,
                          'timeStamp': DateTime.now().toString()
                        });
                        textController.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamBubble extends StatelessWidget {
  late bool isMe;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('messages').orderBy('timeStamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        // final messages = snapshot.data!.docs.reversed;
        // List<MessageBubble> messagesWidget = [];
        // for (var message in messages) {
        //   final messageText = message.data()['text'];
        //   final messageSender = message.data()['sender'];
        //   final currentUser = userLogged!.email;
        //   final messageWidget = MessageBubble(
        //       text: messageText,
        //       sender: messageSender,
        //       isMe: currentUser == messageSender);
        //   messagesWidget.add(messageWidget);
        // }

        return Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final messageSender = snapshot.data!.docs[index]['sender'];
                final currentUser = userLogged!.email;
                return MessageBubble(
                  text: snapshot.data!.docs[index]['text'],
                  sender: messageSender,
                  isMe: currentUser == messageSender,
                );
              }),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  MessageBubble({required this.text, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // align the position of text from different users
        crossAxisAlignment:
            isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black45),
          ),
          Material(
            elevation: 5.0,
            color: isMe == true ? Colors.blueAccent : Colors.white,
            borderRadius: isMe == true
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15.0,
                    color: isMe == true ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
