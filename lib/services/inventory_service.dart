import 'package:flutter/material.dart';

class InventoryService extends ChangeNotifier {
  final List<Map<String, String>> _objets = [];

  List<Map<String, String>> get objets => List.unmodifiable(_objets);

  void ajouterObjet(String nom, String image, String description) {
    _objets.add({
      'nom': nom,
      'image': image,
      'description': description,
    });
    notifyListeners();
  }

  void viderInventaire() {
    _objets.clear();
    notifyListeners();
  }
}
