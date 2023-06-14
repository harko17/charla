import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  var _enteredMessage = '';
  final _controller = new TextEditingController();
  Future<void> _sendMessage()
  async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final del_id = Random().nextInt(60000).toString();
    FirebaseFirestore.instance.
    collection('chat').doc(del_id).set({
      'del_id': del_id,
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'userName': userData['userName'],
      'userImage':userData['image_url'],
    });
    setState(() {
      _controller.clear();
      _enteredMessage = '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
                borderSide: new BorderSide(
                  color: Colors.purple,
                  width: 1.0,
                ),
              ),
              labelText: 'Send a message...',),
            onChanged: (value){
              setState(() {
                _enteredMessage = value;
              });
            },
          ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              color: Theme .of(context).primaryColor,
              icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
