import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'scenario.dart';

class Dao {
  //La reférence de notre base de données
  static Database? _database;

  //Un getter qui renvoie l'objet de base de donnée.
  //Si la base n'existe pas _initDB la créé
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('folkloric.db');
    return _database!;
  }

  //_initDB initialise notre base de données.
  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    //openDatabase ouvre notre base de données située à l'emplacement "path"
    //si la base n'existe pas openDatabase exécute _createDB
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //_createDB est la méthode qui s'occupe de la définition des tables de notre base de données
  //_createDB exécute les transactions de base de données pour créer les tables
  static Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE scenario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        description TEXT NOT NULL,
        piste_audio TEXT NOT NULL
      ) 
    ''');

  }

  //Lecture de Scenario
  static Future<List<Scenario>> listeScenario() async {
    final db = await database;

    final maps = await db.query(
      "scenario",
      columns: ["*"],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Scenario.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  //Insertion
  static Future<Scenario> createScenario(Scenario scenario) async {
    final db = await database;
    final id = await db.insert("scenario", scenario.toJson());
    scenario.id = id;
    return scenario;
  }

  //Modification - Mise à Jour
  static Future<int> updateScenario(Scenario scenario) async {
    final db = await database;
    Map<String, dynamic> data = scenario.toJson();
    data.remove("id"); //Nous prenons soin de supprimer le champs id avec ..remove("id")
    return db.update(
      "scenario",
      data,
      where: 'id = ?',
      whereArgs: [scenario.id],
    );
  }

  //Suppression
  static Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      "scenario",
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}