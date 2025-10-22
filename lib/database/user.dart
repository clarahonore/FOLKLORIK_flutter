class User {
  int? id;
  String? nom;
  String? prenom;
  String? mail;

  User({this.id, this.nom, this.prenom, this.mail});

  //transaction
  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    nom = json["nom"];
    prenom = json["prenom"];
    mail = json["mail"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["nom"] = nom;
    map["prenom"] = prenom;
    map["mail"] = mail;
    return map;
  }
}