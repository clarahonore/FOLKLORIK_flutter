import 'package:flutter/material.dart';

class AccessibiliteStatus extends ChangeNotifier {
  bool sonActive = true;
  bool contraste = false;
  bool daltonisme = false;
  bool texteGrand = false;
  bool narrationActive = false;

  void toggleSon() {
    sonActive = !sonActive;
    notifyListeners();
  }

  void toggleContraste() {
    contraste = !contraste;
    notifyListeners();
  }

  void toggleDaltonisme() {
    daltonisme = !daltonisme;
    notifyListeners();
  }

  void toggleTexteGrand() {
    texteGrand = !texteGrand;
    notifyListeners();
  }

  void toggleNarration() {
    narrationActive = !narrationActive;
    notifyListeners();
  }
}
