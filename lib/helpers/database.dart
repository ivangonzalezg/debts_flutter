import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String clientsTable = "clients";
final String invoicesTable = "invoices";
final String idColumn = "id";
final String nameColumn = "name";
final String colorColumn = "color";
final String clientIdColumn = "client_id";
final String amountColumn = "amount";
final String descriptionColumn = "description";
final String createdAtColumn = "created_at";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Null> createTables(Database db) async {
    await db.execute(
        "CREATE TABLE $clientsTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $colorColumn TEXT, $createdAtColumn TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
    await db.execute(
        "CREATE TABLE $invoicesTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $clientIdColumn INTEGER, $amountColumn INTEGER, $descriptionColumn TEXT, $createdAtColumn TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY($clientIdColumn) REFERENCES $clientsTable($idColumn))");
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "money_manager.db");
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
            "CREATE TABLE $clientsTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $colorColumn TEXT, $createdAtColumn TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
        await db.execute(
            "CREATE TABLE $invoicesTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $clientIdColumn INTEGER, $amountColumn INTEGER, $descriptionColumn TEXT, $createdAtColumn TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY($clientIdColumn) REFERENCES $clientsTable($idColumn))");
      },
      onUpgrade: (Database db, int version, int newVersion) async {
        await db.execute("DROP TABLE IF EXISTS $clientsTable");
        await db.execute("DROP TABLE IF EXISTS $invoicesTable");
        await createTables(db);
      },
    );
  }

  Future<Client> saveClient(Client client) async {
    Database database = await db;
    client.createdAt = DateTime.now().toString();
    client.color = RandomColor().randomColor().toString();
    client.id = await database.insert(clientsTable, client.toMap());
    return client;
  }

  Future<Invoice> saveInvoice(Invoice invoice) async {
    Database database = await db;
    invoice.createdAt = DateTime.now().toString();
    invoice.id = await database.insert(invoicesTable, invoice.toMap());
    return invoice;
  }

  Future<Client> getClient(int id) async {
    Database database = await db;
    List<Map> maps = await database.query(clientsTable,
        columns: [idColumn, nameColumn, colorColumn, createdAtColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Client.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Invoice> getInvoice(int id) async {
    Database database = await db;
    List<Map> maps = await database.query(clientsTable,
        columns: [idColumn, clientIdColumn, amountColumn, createdAtColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Invoice.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteClient(int id) async {
    Database database = await db;
    return await database
        .delete(clientsTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> deleteInvoice(int id) async {
    Database database = await db;
    return await database
        .delete(invoicesTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateClient(Client client) async {
    Database database = await db;
    return await database.update(clientsTable, client.toMap(),
        where: "$idColumn = ?", whereArgs: [client.id]);
  }

  Future<int> updateInvoice(Invoice invoice) async {
    Database database = await db;
    return await database.update(invoicesTable, invoice.toMap(),
        where: "$idColumn = ?", whereArgs: [invoice.id]);
  }

  Future<List> getAllClients() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM $clientsTable");
    List<Client> listClient = List();
    for (Map m in listMap) {
      listClient.add(Client.fromMap(m));
    }
    return listClient;
  }

  Future<List> getAllInvoices() async {
    Database database = await db;
    List listMap = await database.rawQuery(
        "SELECT $invoicesTable.$idColumn, $clientsTable.$idColumn as clientId, $clientsTable.$nameColumn as clientName, $invoicesTable.$amountColumn, $invoicesTable.$descriptionColumn, $invoicesTable.$createdAtColumn FROM $invoicesTable INNER JOIN $clientsTable ON $invoicesTable.$clientIdColumn = $clientsTable.$idColumn");
    List<InvoiceResponse> listInvoice = List();
    for (Map m in listMap) {
      listInvoice.add(InvoiceResponse.fromMap(m));
    }
    return listInvoice;
  }

  Future close() async {
    Database database = await db;
    database.close();
  }
}

class Client {
  int id;
  String name;
  String color;
  String createdAt;

  Client();

  Client.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    color = map[colorColumn];
    createdAt = map[createdAtColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      colorColumn: color,
      createdAtColumn: createdAt,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Client (id: $id, name: $name, color: $color, created_at: $createdAt)";
  }
}

class Invoice {
  int id;
  int clientId;
  int amount;
  String description;
  String createdAt;

  Invoice();

  Invoice.fromMap(Map map) {
    id = map[idColumn];
    clientId = map[clientIdColumn];
    amount = map[amountColumn];
    description = map[descriptionColumn];
    createdAt = map[createdAtColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      clientIdColumn: clientId,
      amountColumn: amount,
      descriptionColumn: description,
      createdAtColumn: createdAt,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Invoice (id: $id, client_id: $clientId, amount: $amount, description: $description ,created_at: $createdAt)";
  }
}

class InvoiceResponse {
  int id;
  String clientName;
  int clientId;
  int amount;
  String description;
  String createdAt;

  InvoiceResponse();

  InvoiceResponse.fromMap(Map map) {
    id = map[idColumn];
    clientName = map["clientName"];
    clientId = map["clientId"];
    amount = map[amountColumn];
    description = map[descriptionColumn];
    createdAt = map[createdAtColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      "clientName": clientName,
      "clientId": clientId,
      amountColumn: amount,
      descriptionColumn: description,
      createdAtColumn: createdAt,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "InvoiceResponse (id: $id, client_name: $clientName, client_id: $clientId ,amount: $amount, description: $description, created_at: $createdAt)";
  }
}
