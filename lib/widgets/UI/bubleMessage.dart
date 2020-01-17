import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BubleMessage extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  BubleMessage({this.message, this.sender,this.isMe});
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            Material(
              borderRadius: isMe? BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)):
                  BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              elevation: 5.0,
              color:isMe? Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Text(
                  message,
                  style: TextStyle(color:isMe? Colors.white:Colors.black, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ));
  }
}
