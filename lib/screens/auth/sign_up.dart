import 'package:debts/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign_up';

  @override
  _State createState() => _State();
}

class _State extends State<SignUpScreen> {
  final AuthService _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
