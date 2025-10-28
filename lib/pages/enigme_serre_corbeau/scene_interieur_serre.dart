import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/inventory_button.dart';
import '../../widgets/timer_button.dart';
import '../nouvelle_enigme1/scene_serre_interactive.dart';

class SceneInterieurSerre extends StatefulWidget {
  const SceneInterieurSerre({super.key});

  @override
  State<SceneInterieurSerre> createState() => _SceneInterieurSerreState();
}

class _SceneInterieurSerreState extends State<SceneInterieurSerre>
    with TickerProviderStateMixin {
  bool _planteArrose = false;
  bool _animationEnCours = false;
  String _message = "";

  late AnimationController _magicController;
  late Animation<double> _magicOpacity;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) {
        timer.toggle();
      }
    });

    _magicController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _magicOpacity =
        CurvedAnimation(parent: _magicController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _magicController.dispose();
    super.dispose();
  }

  Future<void> _utiliserEau(BuildContext context) async {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.possedeObjet("Calice d’eau pure")) {
      setState(() {
        _animationEnCours = true;
      });

      await _magicController.forward();

      setState(() {
        _planteArrose = true;
        _message =
        "✨ Bravo ! La plante vous a offert des graines magiques.\nElles vous seront utiles pour la suite.";
      });

      inventory.retirerObjet("Calice d’eau pure");
      inventory.ajouterObjet(
        "Graines magiques",
        "assets/images/graines.png",
        "Des graines luisantes offertes par la plante mystique.",
      );

      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _animationEnCours = false;
      });
    } else {
      setState(() {
        _message =
        "💧 Il vous faut l’eau pure de la Source Viviane pour arroser la plante.";
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
            _planteArrose
                ? "assets/images/interieur_serre_fleur.png"
                : "assets/images/interieur_serre.png",
            fit: BoxFit.cover,
          ),

          const TimerButton(),

          if (_animationEnCours)
            FadeTransition(
              opacity: _magicOpacity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                    center: Alignment.center,
                  ),
                ),
              ),
            ),

          if (!_planteArrose)
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _animationEnCours ? null : () => _utiliserEau(context),
                  icon: const Icon(Icons.water_drop, color: Colors.white),
                  label: const Text(
                    "Arroser la plante",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

          if (_message.isNotEmpty)
            Positioned(
              bottom: 40,
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
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SceneSerreInteractive()),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour à la serre"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                foregroundColor: Colors.white,
              ),
            ),
          ),

          const InventoryButton(),
        ],
      ),
    );
  }
}