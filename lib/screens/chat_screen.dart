import 'package:chat_with_me/screens/welcome_screen.dart';
import 'package:chat_with_me/widgets/UI/bubleMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String message;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUer();
  }

  void getCurrentUer() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something Went Wrong!!'),
              content: Text(e.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            );
          });
    }
  }

  Widget _stream_builder() {
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<BubleMessage> messageBubles = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];

            final messageBuble = BubleMessage(
              message: messageText,
              sender: messageSender,
              isMe: loggedInUser.email == messageSender,
            );
            messageBubles.add(messageBuble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubles,
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something Went Wrong!!'),
              content: Text(e.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            );
          });
      return Container(
        child: Text(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Center(
          child: Image.asset(
            'assets/images/icons/logo.png',
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _stream_builder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      try {
                        messageController.clear();
                        firestore.collection('messages').add({
                          'sender': loggedInUser.email,
                          'text': message,
                          'time': DateTime.now()
                        });
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Something Went Wrong!!'),
                                content: Text(e.toString()),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Okay'),
                                  )
                                ],
                              );
                            });
                      }
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
    );
  }
}
