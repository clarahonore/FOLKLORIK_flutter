import 'package:flutter/material.dart';
import 'package:mon_app/pages/enigme_fee/scene_enigme_fee.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/timer_button.dart';
import '../../widgets/inventory_button.dart';

class SceneFeeIntro extends StatefulWidget {
  const SceneFeeIntro({super.key});

  @override
  State<SceneFeeIntro> createState() => _SceneFeeIntroState();
}

class _SceneFeeIntroState extends State<SceneFeeIntro> {
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) timer.toggle();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              "assets/images/fee_face.png",
              width: 280,
            ),
          ),

          const TimerButton(),

          const InventoryButton(),

          if (_showText)
            Positioned(
              bottom: 160,
              left: 30,
              right: 30,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(seconds: 1),
                child: const Text(
                  "« Vous voilà enfin... Vous entendez ?\n"
                      "La forêt murmure... La clé est cachée,\n"
                      "mais seule une oreille attentive saura l'entendre... »",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SceneEnigmeFee()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continuer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}