import 'package:charla/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Messages extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final uid = user!.uid;
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
      builder: (ctx, chatSnapshot)
      {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitRotatingCircle(
              color: Colors.purple,
              size: 30.0,
            ),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        if(chatSnapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['del_id'],
                chatDocs[index]['text'],
                key: ValueKey(chatDocs[index].id),
                chatDocs[index]['userName'].toString(),
                chatDocs[index]['userImage'].toString(),
                (chatDocs[index]['userId'] == uid),
              ),
            );
          }
        return Text('No data');
        });

  }
}
