import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_messenger/Component/padding_button.dart';
import 'package:instant_messenger/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'reg_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? password;
  String? email;
  bool handleSpin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: handleSpin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 400.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kDecorationField.copyWith(hintText: 'Enter email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kDecorationField.copyWith(
                  hintText: 'Enter password',
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              TextPadding(
                title: 'Register',
                onTap: () async {
                  setState(() {
                    handleSpin = true;
                  });
                  var newUser = await _auth.createUserWithEmailAndPassword(
                      email: email!, password: password!);
                  try {
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      // go to next page set the loader spin to false
                      handleSpin = false;
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
