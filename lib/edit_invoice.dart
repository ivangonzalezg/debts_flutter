import 'package:debts/helpers/constants.dart';
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

  InvoiceResponse invoice;

  TextEditingController _amountController;

  TextEditingController _descriptionController;

  String selectedClient;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final InvoiceArguments args = ModalRoute.of(context).settings.arguments;
    invoice = args.invoice;
    selectedClient = args.invoice.clientId.toString();
    _descriptionController =
        TextEditingController(text: args.invoice.description.toString());
    _amountController =
        TextEditingController(text: args.invoice.amount.toString());
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
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text('Edit Invoice'),
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
                decoration: textInputDecoration,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _amountController,
                validator: (value) =>
                    value.isEmpty ? 'Please enter an amount' : null,
                decoration: textInputDecoration.copyWith(
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
                decoration: textInputDecoration.copyWith(
                  labelText: "Description (Opcional)",
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton.icon(
                onPressed: () => _formKey.currentState.validate()
                    ? updateInvoice(
                        invoice,
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
