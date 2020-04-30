import 'package:debts/add_client.dart';
import 'package:debts/add_invoice.dart';
import 'package:debts/edit_client.dart';
import 'package:debts/clients.dart';
import 'package:debts/edit_invoice.dart';
import 'package:debts/invoices.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debst',
      home: InvoicesScreen(),
      routes: <String, WidgetBuilder>{
        ClientsScreen.routeName: (BuildContext context) => ClientsScreen(),
        AddClientScreen.routeName: (BuildContext context) => AddClientScreen(),
        AddInvoiceScreen.routeName: (BuildContext context) =>
            AddInvoiceScreen(),
        EditClientScreen.routeName: (BuildContext context) =>
            EditClientScreen(),
        EditInvoiceScreen.routeName: (BuildContext context) =>
            EditInvoiceScreen(),
      },
    );
  }
}
