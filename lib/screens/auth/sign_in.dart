import 'package:debts/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.all(28),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                FirebaseUser user = await _authService.signInAnon();
                if (user == null) {
                  print("error");
                } else {
                  print(user.uid);
                }
              },
              child: Text("Sign In Anonymously"),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
