import 'package:debts/add_client.dart';
import 'package:debts/clients.dart';
import 'package:debts/helpers/database.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Money Manager'),
      routes: <String, WidgetBuilder>{
        "clients": (BuildContext context) => Clients(),
        "add_client": (BuildContext context) => AddClient(),
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

  @override
  void initState() {
    helper.db;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(28),
        child: Text(
          'You have pushed the button this many times:',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Add Invoice"),
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
                  Navigator.pushNamed(context, "clients");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
