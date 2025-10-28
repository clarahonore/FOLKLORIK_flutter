import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/inventory_button.dart';
import '../../widgets/timer_button.dart';

class SceneCorbeauEnigme extends StatefulWidget {
  const SceneCorbeauEnigme({super.key});

  @override
  State<SceneCorbeauEnigme> createState() => _SceneCorbeauEnigmeState();
}

class _SceneCorbeauEnigmeState extends State<SceneCorbeauEnigme> {
  bool _showText = false;
  bool _animationEnCours = false;
  bool _cleRecuperee = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) {
        timer.toggle();
      }
    });
  }

  void _toggleText() {
    setState(() {
      _showText = !_showText;
    });
  }

  Future<void> _donnerGraines(BuildContext context) async {
    if (_animationEnCours) return;

    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (!inventory.possedeObjet("Graines magiques")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🌾 Tu n’as pas de graines à donner au corbeau."),
          backgroundColor: Colors.brown,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _animationEnCours = true);
    inventory.retirerObjet("Graines magiques");

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 3), () {
          if (dialogContext.mounted) Navigator.pop(dialogContext);
        });

        return Container(
          color: Colors.black.withOpacity(0.85),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Vous avez donné les graines au corbeau.\n"
                    "Il les picore avec avidité...\n"
                    "Puis laisse tomber une clé brillante à vos pieds ! 🗝️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ),
        );
      },
    );

    inventory.marquerCleCorbeauRecuperee();

    inventory.ajouterObjet(
      "Clé ancienne",
      "assets/images/cle_fee.png", // ou ton image de clé
      "Une clé ancienne laissée par le corbeau. Elle semble ouvrir la cabane.",
    );

    setState(() {
      _cleRecuperee = true;
      _animationEnCours = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🗝️ Tu as obtenu la clé de la cabane !"),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryService>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _toggleText,
            child: Image.asset(
              "assets/images/corbeau_enigme.png",
              fit: BoxFit.cover,
            ),
          ),

          const TimerButton(),

          if (_showText)
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.white.withOpacity(0.65),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _cleRecuperee
                          ? "Le corbeau t’a déjà donné la clé.\nTu peux maintenant ouvrir la cabane !"
                          : "« Le corbeau semble avoir une clé autour de la patte.\n"
                          "Ce serait peut-être la clé de la cabane...\n"
                          "Mais comment la prendre ? »",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const InventoryButton(),

          if (inventory.possedeObjet("Graines magiques") && !_cleRecuperee)
            Positioned(
              bottom: 110,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () => _donnerGraines(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text(
                  "Donner les graines au corbeau",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_back, size: 22),
              label: const Text(
                "Retour",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}