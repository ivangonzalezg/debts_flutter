import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditInvoiceScreen(),
    theme: ThemeData(primaryColor: Colors.white),
  ));
}

class InvoiceArguments {
  final InvoiceResponse invoice;

  InvoiceArguments(this.invoice);
}

class EditInvoiceScreen extends StatefulWidget {
  static const routeName = '/edit_invoice';

  @override
  _State createState() => _State();
}

class _State extends State<EditInvoiceScreen> {
  DatabaseHelper helper = DatabaseHelper();

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  List<Client> clients = List();

  TextEditingController _amountController;

  TextEditingController _descriptionController;

  String selectedClient;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<Null> updateInvoice(
    InvoiceResponse invoiceResponse,
    String amount,
    String description,
  ) async {
    try {
      Invoice invoice = new Invoice();
      invoice.id = invoiceResponse.id;
      invoice.clientId = int.parse(selectedClient);
      invoice.amount = int.parse(amount);
      invoice.description = description;
      invoice.createdAt = invoiceResponse.createdAt;
      await helper.updateInvoice(invoice);
      Navigator.pop(context);
    } catch (error) {
      _scaffold.currentState.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final InvoiceArguments args = ModalRoute.of(context).settings.arguments;

    if (selectedClient == null &&
        _descriptionController == null &&
        _amountController == null) {
      setState(() {
        selectedClient = args.invoice.clientId.toString();
        _descriptionController =
            TextEditingController(text: args.invoice.description.toString());
        _amountController =
            TextEditingController(text: args.invoice.amount.toString());
      });
    }

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Container(
        padding: EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedClient,
                onChanged: (String newValue) {
                  setState(() {
                    selectedClient = newValue;
                  });
                },
                items: clients.map<DropdownMenuItem<String>>(
                  (Client client) {
                    return DropdownMenuItem<String>(
                      value: client.id.toString(),
                      child: Text(client.name),
                    );
                  },
                ).toList(),
                hint: Text("Select a client"),
                isExpanded: true,
                validator: (value) =>
                    value == null ? 'Please selected a client' : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _amountController,
                validator: (value) =>
                    value.isEmpty ? 'Please enter an amount' : null,
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description (Opcional)",
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton.icon(
                onPressed: () => _formKey.currentState.validate()
                    ? updateInvoice(
                        args.invoice,
                        _amountController.text.toString(),
                        _descriptionController.text.toString(),
                      )
                    : null,
                label: Text("Save"),
                icon: Icon(Icons.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initState() async {
    List<Client> list = await helper.getAllClients();
    setState(() {
      clients = list;
    });
  }
}
