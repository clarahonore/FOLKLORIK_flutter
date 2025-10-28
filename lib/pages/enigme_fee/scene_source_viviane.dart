import 'package:flutter/material.dart';
import 'package:mon_app/pages/enigme_fee/scene_enigme_fee.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/inventory_button.dart';
import '../../widgets/timer_button.dart';

class SceneSourceViviane extends StatefulWidget {
  const SceneSourceViviane({super.key});

  @override
  State<SceneSourceViviane> createState() => _SceneSourceVivianeState();
}

class _SceneSourceVivianeState extends State<SceneSourceViviane> {
  final TextEditingController _answerController = TextEditingController();
  String _message = "";
  bool _enigmeTerminee = false;
  bool _caliceRecupere = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) timer.toggle();
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _verifierReponse() {
    final reponse = _answerController.text.trim().toLowerCase();
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (reponse == "humain" || reponse == "l'humain" || reponse == "un humain") {
      if (!_caliceRecupere) {
        inventory.ajouterObjet(
          "Calice sacré",
          "assets/images/calice.png",
          "Un calice ancien et sacré, offert par Viviane. Permet de recueillir l’eau pure de la source.",
        );
        inventory.marquerCaliceRecupere();

        setState(() {
          _enigmeTerminee = true;
          _caliceRecupere = true;
          _message = "✨ Bravo ! Viviane vous offre le Calice sacré !";
        });
      }
    } else {
      setState(() {
        _message =
        "❌ Viviane sourit doucement... « Ce n’est pas la bonne réponse. »";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/source_viviane.png",
            fit: BoxFit.cover,
          ),

          const TimerButton(),

          const InventoryButton(),

          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SceneEnigmeFee()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                "Retour",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.black.withOpacity(0.5),
                child: const Text(
                  "La fée Viviane vous accueille 💧",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Viviane : « Pour ne pas salir la pureté de l’eau, il te faudra un calice. "
                    "Je te le prêterai si tu réponds à ma devinette : »\n\n"
                    "❓ “Qu’est-ce qui commence sa vie sur 4 pattes, la continue sur 2 et la finit sur 3 ?”",
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          if (!_enigmeTerminee)
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: 240,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _answerController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Votre réponse...",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verifierReponse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Répondre",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

          if (_message.isNotEmpty)
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, height: 1.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}