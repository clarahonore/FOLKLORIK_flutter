import 'package:flutter/foundation.dart';

class InventoryService extends ChangeNotifier {
  final List<Map<String, String>> _objets = [];

  bool coffreOuvert = false;
  bool cleRecuperee = false;
  bool guiRecuperee = false;
  bool caliceRecupere = false;
  bool eauPureRecuperee = false;

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