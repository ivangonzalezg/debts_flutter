import 'package:debts/add_client.dart';
import 'package:debts/client_details.dart';
import 'package:flutter/material.dart';
import 'package:debts/helpers/database.dart';
import 'package:debts/edit_client.dart';
import 'package:intl/intl.dart';

class ClientsScreen extends StatefulWidget {
  static const routeName = '/clients';

  @override
  _State createState() => _State();
}

class _State extends State<ClientsScreen> {
  DatabaseHelper helper = DatabaseHelper();

  List<Client> clients = List();

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getAllClients();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _dateFormatter(String dateString) {
    return new DateFormat("EEEE, LLLL d, yyyy")
        .format(DateTime.parse(dateString));
  }

  Future<Null> _onDelete(int id, String name) async {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Are you sure you want to delete $name"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
            ),
          ),
          FlatButton(
            onPressed: () => _deleteClient(id),
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text("Clients"),
      ),
      body: Container(
        child: _customBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AddClientScreen.routeName).then(
          (v) => _getAllClients(),
        ),
        child: Icon(Icons.person_add),
      ),
    );
  }

  Widget _customBody() {
    if (clients.length > 0) {
      return ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return _clientCard(context, index);
        },
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      );
    }
    return Center(
      child: Text(
        "No clients",
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _clientCard(BuildContext context, int index) {
    Client client = clients[index];
    String valueString = client.color.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color clientColor = new Color(value);
    return Card(
      child: ListTile(
        title: Text(
          clients[index].name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(_dateFormatter(client.createdAt)),
        leading: CircleAvatar(
          child: Text(client.name.substring(0, 1)),
          foregroundColor: Colors.white,
          backgroundColor: clientColor,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(
                context,
                EditClientScreen.routeName,
                arguments: ClientArguments(client),
              ).then(
                (v) => _getAllClients(),
              ),
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () => _onDelete(client.id, client.name),
              color: Colors.red,
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(
          context,
          ClientDetails.routeName,
          arguments: ClientDetailsArguments(client),
        ),
      ),
    );
  }

  void _getAllClients() {
    helper.getAllClients().then((list) {
      setState(() {
        clients = list;
      });
    });
  }

  void _deleteClient(int id) {
    helper.deleteClient(id).then((v) {
      _getAllClients();
      Navigator.pop(context);
    });
  }
}
