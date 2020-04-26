import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String clientsTable = "clients";
final String idColumn = "id";
final String nameColumn = "name";
final String colorColumn = "color";
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

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "money_manager.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
            "CREATE TABLE $clientsTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $colorColumn TEXT, $createdAtColumn TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      },
    );
  }

  Future<Client> saveClient(Client client) async {
    Database dbClient = await db;
    client.createdAt = DateTime.now().toString();
    client.color = RandomColor().randomColor().toString();
    client.id = await dbClient.insert(clientsTable, client.toMap());
    return client;
  }

  Future<Client> getClient(int id) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.query(clientsTable,
        columns: [idColumn, nameColumn, createdAtColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Client.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteClient(int id) async {
    Database dbClient = await db;
    return await dbClient
        .delete(clientsTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateClient(Client client) async {
    Database dbClient = await db;
    return await dbClient.update(clientsTable, client.toMap(),
        where: "$idColumn = ?", whereArgs: [client.id]);
  }

  Future<List> getAllClients() async {
    Database dbClient = await db;
    List listMap = await dbClient.rawQuery("SELECT * FROM $clientsTable");
    List<Client> listClient = List();
    for (Map m in listMap) {
      listClient.add(Client.fromMap(m));
    }
    return listClient;
  }

  Future close() async {
    Database dbClient = await db;
    dbClient.close();
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
    return "Client (id: $id, name: $name, color: $color ,created_at: $createdAt)";
  }
}
