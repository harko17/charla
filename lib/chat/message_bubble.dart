import 'dart:math';

import 'package:charla/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      this.delId,
      this.message,
      this.userName,
      this.userImage,
      this.isMe, {required this.key}

     );

  final Key key;
  final String message;
  final String userName;
  final bool isMe;
  final String userImage;
  final String delId;
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        return Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed:  () {
        FirebaseFirestore.instance.
        collection('chat').doc(delId).delete();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Message"),
      content: Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        pp=delId;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
      },
      onLongPress: (){
        showAlertDialog(context);
      },
      child: Stack(
          children: [
            Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if(!isMe)
                    CircleAvatar(
                      backgroundImage: NetworkImage(userImage),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: !isMe ? Theme.of(context).primaryColor : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                            bottomRight: !isMe ? Radius.circular(0) : Radius.circular(12),
                          )),
                      width: 140,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if(!isMe)
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: !isMe ? Colors.primaries[userName.codeUnitAt(2)<=113 ? userName.codeUnitAt(2)-96 : userName.codeUnitAt(2)-113] : Theme.of(context).primaryColorDark),
                          ),
                          Text(
                            message,
                            style:
                                TextStyle(color: !isMe ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                    if(isMe)
                      CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      ),
                  ],
                ),
              ],
            ),

          ],
        clipBehavior: Clip.none,
      ),
    );
  }
}
