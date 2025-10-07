class Scenario {
  int? id;
  String? nom;
  String? description;
  String? pisteAudio;

  Scenario({this.id, this.nom, this.description, this.pisteAudio});

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
}