import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/LandT.png'),
            ),
            Center(
              child: Column(
                children: [
                  Text('Created and designed by',style: TextStyle(color: Colors.white,fontSize: 25),),

                  Text('HARSH KOTARY',style: TextStyle(color: Colors.white,fontSize: 25),),
                  Text('harshkotary@gmail.com',style: TextStyle(color: Colors.red,fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/linkedin.png'),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
_launchURL() async {
  final Uri url = Uri.parse('https://in.linkedin.com/in/harsh-kotary-84b715227');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}