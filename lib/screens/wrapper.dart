import 'package:debts/invoices.dart';
import 'package:debts/screens/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return SignInScreen();
    } else {
      return InvoicesScreen();
    }
  }
}
