import 'package:debts/add_invoice.dart';
import 'package:debts/clients.dart';
import 'package:debts/edit_invoice.dart';
import 'package:debts/helpers/database.dart';
import 'package:debts/services/auth.dart';
import 'package:debts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class InvoicesScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<InvoicesScreen> {
  final AuthService _authService = AuthService();
  DatabaseHelper helper = DatabaseHelper();
  ProgressDialog progressDialog;

  List<InvoiceResponse> invoices = List();

  @override
  void initState() {
    _initState();
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    super.initState();
  }

  Future<Null> updateFirebase(FirebaseUser user) async {
    await progressDialog.show();
    List<Client> clients = await helper.getAllClients();
    await Stream.fromIterable(clients)
        .asyncMap(
            (_client) => DatabaseService(uid: user.uid).saveClient(_client))
        .toList();
    List<Invoice> invoices = await helper.getAllInvoicesRaw();
    await Stream.fromIterable(invoices)
        .asyncMap(
            (_invoice) => DatabaseService(uid: user.uid).saveInvoice(_invoice))
        .toList();
    await progressDialog.hide();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
      body: _invoicesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AddInvoiceScreen.routeName).then(
          (v) => _initState(),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName.toString()),
                accountEmail: Text(user.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blue[800],
                  child: Text("IG"),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                ),
              ),
              ListTile(
                title: Text("Clients"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ClientsScreen.routeName).then(
                    (v) => _initState(),
                  );
                },
                leading: Icon(Icons.person),
              ),
              Divider(),
              ListTile(
                title: Text("Sync up"),
                onTap: () => updateFirebase(user),
                leading: Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoicesList() {
    if (invoices.length > 0) {
      final formatCurrency = new NumberFormat.simpleCurrency(
        decimalDigits: 0,
        name: "COP",
      );
      int total = invoices.fold(0, (t, i) => t + i.amount);
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(formatCurrency.format(total)),
                trailing: Icon(
                  total > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: total > 0 ? Colors.green : Colors.red,
                  size: 35,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Summary",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 20,
            ),
            new Expanded(
              child: ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  return _invoiceCard(context, index);
                },
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        "No invoices",
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _invoiceCard(BuildContext context, int index) {
    InvoiceResponse invoice = invoices[index];
    final formatCurrency = new NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: "COP",
    );
    return Card(
      child: ListTile(
        title: Text(
          formatCurrency.format(invoice.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(invoice.clientName),
        trailing: Icon(
          invoice.amount > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: invoice.amount > 0 ? Colors.green : Colors.red,
          size: 35,
        ),
        onTap: () => Navigator.pushNamed(
          context,
          EditInvoiceScreen.routeName,
          arguments: InvoiceArguments(invoice),
        ).then(
          (v) => _initState(),
        ),
      ),
    );
  }

  void _initState() async {
    List<InvoiceResponse> list = await helper.getAllInvoices();
    setState(() {
      invoices = list;
    });
  }
}
