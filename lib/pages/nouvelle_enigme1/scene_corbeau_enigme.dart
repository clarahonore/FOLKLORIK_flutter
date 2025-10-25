import 'package:flutter/material.dart';

class SceneCorbeauEnigme extends StatefulWidget {
  const SceneCorbeauEnigme({super.key});

  @override
  State<SceneCorbeauEnigme> createState() => _SceneCorbeauEnigmeState();
}

class _SceneCorbeauEnigmeState extends State<SceneCorbeauEnigme> {
  bool _showText = false;

  void _toggleText() {
    setState(() {
      _showText = !_showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ Image de fond
          GestureDetector(
            onTap: _toggleText,
            child: Image.asset(
              "assets/images/corbeau_enigme.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🖋️ Texte central (affiché au clic)
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
                      "« Le corbeau semble avoir une clé autour de la patte.\n"
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

          // 🔙 Bouton Retour
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