import 'package:debts/add_client.dart';
import 'package:debts/add_invoice.dart';
import 'package:debts/edit_client.dart';
import 'package:debts/clients.dart';
import 'package:debts/edit_invoice.dart';
import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      home: MyHomePage(title: 'Money Manager'),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper helper = DatabaseHelper();

  List<InvoiceResponse> invoices = List();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                accountName: Text("Ivan Gonzalez"),
                accountEmail: Text("ivangonzalezgrc@gmail.com"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoicesList() {
    if (invoices.length > 0) {
      return ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          return _invoiceCard(context, index);
        },
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
