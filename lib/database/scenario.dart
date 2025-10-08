import 'dao.dart';

class Scenario extends Dao {
  int? id;
  String? nom;
  String? description;
  String? pisteAudio;

  Scenario({this.id, this.nom, this.description, this.pisteAudio});

  //transaction
  Scenario.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    nom = json["nom"];
    description = json["description"];
    pisteAudio = json["piste_audio"];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map ={};
    map["id"] = id;
    map["nom"] = nom;
    map["description"] = description;
    map["piste_audio"];
    return map;

  }

  //Lecture
  static Future<List<Scenario>> listeScenario() async {
    final db = await Dao.database;

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
    final db = await Dao.database;
    final id = await db.insert("scenario", scenario.toJson());
    scenario.id = id;
    return scenario;
  }

  //Modification - Mise à Jour
  static Future<int> updateScenario(Scenario scenario) async {
    final db = await Dao.database;
    return db.update(
      "scenario",
      scenario.toJson().remove("id"), //Nous prenons soin de supprimer le champs id avec ..remove("id")
      where: 'id = ?',
      whereArgs: [scenario.id],
    );
  }

  //Suppression
  static Future<int> delete(int id) async {
    final db = await Dao.database;
    return await db.delete(
      "scenario",
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}