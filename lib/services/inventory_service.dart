import 'package:flutter/foundation.dart';

class InventoryService extends ChangeNotifier {
  final List<Map<String, String>> _objets = [];

  bool coffreOuvert = false;
  bool cleRecuperee = false;
  bool guiRecuperee = false;
  bool caliceRecupere = false;
  bool eauPureRecuperee = false;
  bool possedeObjet(String nom) {
    return _objets.any((obj) => obj['nom'] == nom);
  }
  bool serreDeverrouillee = false;

  bool cabaneDeverrouillee = false;
  bool cleRecupereeParCorbeau = false;

  void marquerCabaneDeverrouillee() {
    cabaneDeverrouillee = true;
    notifyListeners();
  }

  void marquerCleCorbeauRecuperee() {
    cleRecupereeParCorbeau = true;
    ajouterObjet(
      "Clé ancienne",
      "assets/images/cle.png",
      "Une clé ancienne offerte par le corbeau après lui avoir donné les graines.",
    );
    notifyListeners();
  }

  void marquerSerreDeverrouillee() {
    serreDeverrouillee = true;
    notifyListeners();
  }

  void retirerObjet(String nom) {
    _objets.removeWhere((obj) => obj['nom'] == nom);
    notifyListeners();
  }

  void marquerGuiRecuperee() {
    guiRecuperee = true;
    notifyListeners();
  }
  void marquerCaliceRecupere() {
    caliceRecupere = true;
    notifyListeners();
  }

  void marquerEauPureRecuperee() {
    eauPureRecuperee = true;
    notifyListeners();
  }

  List<Map<String, String>> get objets => List.unmodifiable(_objets);

  void ajouterObjet(String nom, String image, String description) {
    final existe = _objets.any((obj) => obj['nom'] == nom);
    if (!existe) {
      _objets.add({
        'nom': nom,
        'image': image,
        'description': description,
      });
      notifyListeners();
    }
  }

  void marquerCoffreOuvert() {
    coffreOuvert = true;
    notifyListeners();
  }

  void marquerCleRecuperee() {
    cleRecuperee = true;
    notifyListeners();
  }

  void viderInventaire() {
    _objets.clear();
    coffreOuvert = false;
    cleRecuperee = false;
    notifyListeners();
  }
}