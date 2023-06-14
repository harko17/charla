import 'dart:io';

import 'package:charla/widgets/pickers/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
bool obs = true;
class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn,this.isLoading);
  final bool isLoading;
  final void Function(
      String email,
      String userName,
      String password,
      File image,
      bool isLogin,
      BuildContext ctx,) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail='';
  var _userName='';
  var _userPassword='';
  File? _userImageFile;
  void _pickedImage(File image)
  {
      _userImageFile = image;
  }

   _trySubmit()
  {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(_userImageFile == null && !_isLogin)
      {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please pick an image'),backgroundColor: Colors.black12,),
          );
        });
        return;
      }
    else if(_userImageFile == null && _isLogin)
      {
        setState(() {
          _userImageFile = File('path');

        });

      }

    if (isValid)
    {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail.trim(),
          _userName.trim(),
          _userPassword.trim(),
          _userImageFile!,
          _isLogin,
          context
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(_isLogin)
                  Image.asset('assets/logo.png',scale: 3,),
                  Text('CHARLA',style: TextStyle(fontSize: _isLogin?20:25,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                  SizedBox(height: 15,),
                  if(!_isLogin)
                  UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),

                    validator: (value)
                    {
                      if(value!.isEmpty || !value.endsWith('@charla.in'))
                        {
                          return "Invalid email";
                        }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                        ),
                      hintText: 'email@charla.in',
                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                      labelText: 'Email Address'
                    ),
                    onSaved: (value)
                    {
                      _userEmail=value!;
                    },
                  ),
                  SizedBox(height: 12,),
                  if(!_isLogin)
                  TextFormField(
                    key: ValueKey('user'),
                    onSaved: (value)
                    {
                      _userName=value!;
                    },
                    validator: (value)
                    {
                      if(value!.isEmpty)
                        {
                          return "Invalid Username";
                        }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                        ),
                        labelText: 'User name'
                    ),
                  ),
                  SizedBox(height: 12,),

                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value)
                    {
                      if(value!.isEmpty || value.length<6)
                        {
                          return "Short password";
                        }
                      return null;
                    },
                    onSaved: (value)
                    {
                      _userPassword=value!;
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obs=false;
                            Future.delayed(const Duration(milliseconds: 1000), () {
                              setState(() {
                                obs=true;
                              });
                            });
                          });

                        },
                        child: Icon(
                          Icons.remove_red_eye,
                        ),
                      ),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                        ),
                        labelText: 'Password'
                    ),
                    obscureText: obs,

                  ),
                  SizedBox(height: 12,),

                  if(widget.isLoading)
                    SpinKitRotatingCircle(color: Colors.purple,size: 30.0,),
                  if(!widget.isLoading)
                  ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      primary: Colors.purple[100]
                    ),
                    child: Text(_isLogin?"Login":"Signup"),
                  ),
                  if(!widget.isLoading)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin?"Create Account":"I already have an account"),
                  ),
                ],
              ),
              ),
            ),
          )),
    );
  }
}
