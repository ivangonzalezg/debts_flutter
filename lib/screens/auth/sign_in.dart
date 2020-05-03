import 'package:debts/screens/auth/sign_up.dart';
import 'package:debts/services/auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign_in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person_add),
            onPressed: () =>
                Navigator.pushNamed(context, SignUpScreen.routeName),
            label: Text("Sign Up"),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(28),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    print(_emailController.text.toString());
                  },
                  color: Colors.blue,
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
