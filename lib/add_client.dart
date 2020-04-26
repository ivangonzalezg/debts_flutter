import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AddClient(),
  ));
}

class AddClient extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddClient> {
  DatabaseHelper helper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  Future<Null> _addClient() async {
    Client client = new Client();
    client.name = _nameController.text.toString();
    await helper.saveClient(client);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text("Add Client"),
      ),
      body: Container(
        padding: EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
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
                onPressed: () =>
                    _formKey.currentState.validate() ? _addClient() : null,
                label: Text("Add"),
                icon: Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}
