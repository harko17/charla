
import 'dart:io';

import 'package:charla/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
      String email,
      String userName,
      String password,
      File image,
      bool isLogin,
      BuildContext ctx
      ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult =  await _auth.signInWithEmailAndPassword(email: email.trim(),password: password.trim());
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        final ref  = FirebaseStorage.instance.ref().child('user_image')
            .child(authResult.user!.uid + '.jpg');

        String url='';
        await ref.putFile(image).whenComplete(
                () async {
                  url = await ref.getDownloadURL();
                }

        );



        await FirebaseFirestore.instance
            .collection('users').doc(authResult.user!.uid).set(
            {
              'userName': userName,
              'email': email,
              'image_url': url,
            }
        );
      }

    } on PlatformException catch (err)
    {
      var message = "Invalid Input";
      if (err.message != null) {
        message = err.message!;
        print("Error1 is :");
        print(message);
      }
      setState(() {
        _isLoading = false;
      });
    }catch (err)
    {
      print("Error2 is :");
      print(err);

      setState(() {
        ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(isLogin?"Invalid email or password":'Email already in use.'),backgroundColor: Colors.black12,));
      });
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}
