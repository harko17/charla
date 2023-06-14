
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File? selectedImage;

  Future getImage1() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);

    setState(() {
      selectedImage = File(image!.path);
      widget.imagePickFn(selectedImage!);// won't have any error now
    });
  }

  Future getImage2() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);

    setState(() {
      selectedImage = File(image!.path);
      widget.imagePickFn(selectedImage!);// won't have any error now
    });
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Camera"),
      onPressed:  () {
        getImage1();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Gallery"),
      onPressed:  () {
        getImage2();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("UPLOAD"),
      content: Text("Pick image from Camera or Gallery?"),
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
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
        ),
        TextButton(
          onPressed: () {
            showAlertDialog(context);


            // getImage();
            // print('LOL');
          },
          child: Text('Upload Image'),
        ),
      ],
    );
  }
}
