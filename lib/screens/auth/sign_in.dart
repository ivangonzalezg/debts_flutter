import 'package:debts/screens/auth/sign_up.dart';
import 'package:debts/services/auth.dart';
import 'package:debts/shared/constants.dart';
import 'package:debts/shared/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign_in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<Null> _onSignIn() async {
    setState(() => _loading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        _emailController.text.toString(),
        _passwordController.text.toString(),
      );
      setState(() => _loading = false);
    } catch (error) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            key: _scaffold,
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
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => value.isEmpty
                            ? 'Please enter a email'
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
                        onPressed: () => _formKey.currentState.validate()
                            ? _onSignIn()
                            : null,
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
