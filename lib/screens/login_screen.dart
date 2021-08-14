import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_messenger/Component/padding_button.dart';
import 'package:instant_messenger/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool handleSpin = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: handleSpin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
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
                decoration:
                    kDecorationField.copyWith(hintText: 'Enter password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextPadding(
                title: 'Log in ',
                onTap: () async {
                  try {
                    setState(() {
                      handleSpin = true;
                    });
                    var user = await _auth.signInWithEmailAndPassword(
                        email: email!, password: password!);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        handleSpin = false;
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
