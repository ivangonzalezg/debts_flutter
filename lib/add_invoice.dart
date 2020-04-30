import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AddInvoiceScreen(),
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
  ));
}

class AddInvoiceScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddInvoiceScreen> {
  DatabaseHelper helper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  final _amountController = TextEditingController();

  final _descriptionController = TextEditingController();

  List<Client> clients = List();

  String selectedClient;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<Null> _addInvoice(BuildContext context) async {
    try {
      Invoice invoice = new Invoice();
      invoice.clientId = int.parse(selectedClient);
      invoice.amount = int.parse(_amountController.text.toString());
      invoice.description = _descriptionController.text.toString();
      await helper.saveInvoice(invoice);
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
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text("Add Invoice"),
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
                    ? _addInvoice(context)
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
