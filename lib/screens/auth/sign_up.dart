import 'package:debts/services/auth.dart';
import 'package:debts/shared/constants.dart';
import 'package:debts/shared/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign_up';

  @override
  _State createState() => _State();
}

class _State extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<Null> _onSignUp() async {
    setState(() => _loading = true);
    try {
      await _authService.signUpWithEmailAndPassword(
        _emailController.text.toString(),
        _passwordController.text.toString(),
        _nameController.text.toString(),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign Up'),
            ),
            body: Container(
              padding: EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a name' : null,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Name",
                        icon: Icon(
                          Icons.person,
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) => value.isEmpty
                          ? 'Please enter a name'
                          : EmailValidator.validate(value)
                              ? null
                              : "Please enter a valid email",
                      decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        icon: Icon(
                          Icons.email,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) => value.length < 6
                          ? 'Please enter a password 6+ chars long'
                          : null,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        icon: Icon(
                          Icons.lock,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () =>
                          _formKey.currentState.validate() ? _onSignUp() : null,
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
