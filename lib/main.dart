import 'package:debts/add_client.dart';
import 'package:debts/add_invoice.dart';
import 'package:debts/client_details.dart';
import 'package:debts/clients.dart';
import 'package:debts/edit_client.dart';
import 'package:debts/edit_invoice.dart';
import 'package:debts/screens/auth/sign_in.dart';
import 'package:debts/screens/auth/sign_up.dart';
import 'package:debts/screens/wrapper.dart';
import 'package:debts/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Debst',
        home: Wrapper(),
        routes: <String, WidgetBuilder>{
          SignInScreen.routeName: (BuildContext context) => SignInScreen(),
          SignUpScreen.routeName: (BuildContext context) => SignUpScreen(),
          ClientsScreen.routeName: (BuildContext context) => ClientsScreen(),
          AddClientScreen.routeName: (BuildContext context) =>
              AddClientScreen(),
          AddInvoiceScreen.routeName: (BuildContext context) =>
              AddInvoiceScreen(),
          EditClientScreen.routeName: (BuildContext context) =>
              EditClientScreen(),
          EditInvoiceScreen.routeName: (BuildContext context) =>
              EditInvoiceScreen(),
          ClientDetails.routeName: (BuildContext context) => ClientDetails(),
        },
      ),
    );
  }
}
