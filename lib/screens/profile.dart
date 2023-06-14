import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
String pp='';
class Profile extends StatefulWidget {
  const Profile( {Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var stream = FirebaseFirestore.instance.collection('chat').doc(pp).snapshots();
    return StreamBuilder<DocumentSnapshot>(

      stream: stream,
      initialData: null,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          default:

            if (snapshot.hasData) {

              return Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                  body: SafeArea(

                    child: Center(
                      child: Column(

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 120,bottom: 40),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(snapshot.data!['userImage']),
                            ),
                          ),
                          Text(
                            snapshot.data!['userName'].toUpperCase(),

                            style: TextStyle(

                                fontSize: 25.0,
                                color:Colors.white,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),

                                                ],
                      ),
                    ),
                  )
              );

              //this will load first

            }
            else
            {
              return Text("Getting Error");
            }

        }
      },);
  }
}
