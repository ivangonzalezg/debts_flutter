import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debts/helpers/database.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection("users");

  Future<Null> saveClient(Client client) async {
    await usersCollection
        .document(uid)
        .collection("clients")
        .document(client.id.toString())
        .setData(client.toMap());
  }

  Future<Null> saveInvoice(Invoice invoice) async {
    await usersCollection
        .document(uid)
        .collection("invoices")
        .document(invoice.id.toString())
        .setData(invoice.toMap());
  }
}
