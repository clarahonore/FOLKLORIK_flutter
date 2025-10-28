import 'package:flutter/material.dart';
import 'scene_enigme_fee.dart';

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
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _showText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          //  Fée (centrée, elle te regarde)
          Center(
            child: Image.asset(
              "assets/images/fee_face.png",
              width: 280,
            ),
          ),

          // Texte de dialogue
          if (_showText)
            Positioned(
              bottom: 160,
              left: 30,
              right: 30,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(seconds: 1),
                child: Text(
                  "« Vous voilà enfin... Vous entendez ?\n"
                      "La forêt murmure... La clé est cachée,\n"
                      "mais seule une oreille attentive saura l'entendre... »",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ),

          // Bouton Continuer
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SceneEnigmeFee()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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