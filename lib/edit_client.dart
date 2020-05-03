import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

class ClientArguments {
  final Client client;

  ClientArguments(this.client);
}

class EditClientScreen extends StatefulWidget {
  static const routeName = '/edit_client';

  @override
  _State createState() => _State();
}

class _State extends State<EditClientScreen> {
  DatabaseHelper helper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();

  Client client;

  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ClientArguments args = ModalRoute.of(context).settings.arguments;
    client = args.client;
    _nameController = TextEditingController(text: args.client.name);
  }

  Future<Null> updateClient(Client client, String name) async {
    client.name = name;
    await helper.updateClient(client);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
      ),
      body: Container(
        padding: EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value.isEmpty ? "Please enter a name" : null,
                decoration: InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton.icon(
                onPressed: () => _formKey.currentState.validate()
                    ? updateClient(client, _nameController.text.toString())
                    : null,
                label: Text("Save"),
                icon: Icon(Icons.save),
              )
            ],
          ),
        ),
      ),
    );
  }
}
