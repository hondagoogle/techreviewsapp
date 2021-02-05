import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zachnology_tech_reviews/placeholder_widget.dart';
import 'sign_in.dart';
import 'main.dart';
import "package:firebase_auth_oauth/firebase_auth_oauth.dart";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return RaisedButton(
      onPressed: () async {
        await performLogin("github.com", ["email"], {"locale": "en"});
      },
      child: Text("Sign in By Apple"),
    );
  }
}
