import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientDetailsArguments {
  final Client client;

  ClientDetailsArguments(this.client);
}

class ClientDetails extends StatefulWidget {
  static const routeName = '/client_details';

  @override
  _State createState() => _State();
}

class _State extends State<ClientDetails> {
  DatabaseHelper helper = DatabaseHelper();

  Client client;

  List<Invoice> invoices = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ClientDetailsArguments args =
        ModalRoute.of(context).settings.arguments;
    client = args.client;
    getClientInvoices(client.id);
  }

  Future<Null> getClientInvoices(int id) async {
    List<Invoice> list = await helper.getInvoicesByClient(id);
    setState(() {
      invoices = list;
    });
  }

  String _dateFormatter(String dateString) {
    return new DateFormat("EEEE, LLLL d, yyyy")
        .format(DateTime.parse(dateString));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: _invoicesList(),
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
      return Column(
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
    Invoice invoice = invoices[index];
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
        subtitle: Text(_dateFormatter(invoice.createdAt)),
        trailing: Icon(
          invoice.amount > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: invoice.amount > 0 ? Colors.green : Colors.red,
          size: 35,
        ),
      ),
    );
  }
}
