import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditClientScreen(),
  ));
}

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

  final String name = "Hola";

  Future<Null> updateClient(Client client, String name) async {
    client.name = name;
    await helper.updateClient(client);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ClientArguments args = ModalRoute.of(context).settings.arguments;

    final _nameController = TextEditingController(text: args.client.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.client.name),
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
                    ? updateClient(args.client, _nameController.text.toString())
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
