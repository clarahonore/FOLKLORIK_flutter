import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/widgets/app_button.dart';
import 'package:mon_app/pages/enigme_1/intro_apres_1er_enigme.dart';
import 'package:mon_app/pages/inventaire_page.dart';
import 'package:mon_app/services/inventory_service.dart';
import '../../widgets/timer_button.dart';
import '../../services/accessibilite_status.dart';


class EtagerePage extends StatelessWidget {
  const EtagerePage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryService>();
    final access = context.watch<AccessibiliteStatus>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images_fond/etagere.png'),
                fit: BoxFit.cover,
                //alignment: Alignment(0.2, 0.0),
              ),
            ),
          ),

          //1
          Positioned(
            left: screenWidth * 0.05,
            top: screenHeight * 0.25,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                //debugPrint("1er fiole touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true, // ✅ Ferme quand on clique à l'extérieur
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      content: const Text(
                        "Il n'y a rien dans cette fiole.",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.blue.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          //2ème
          Positioned(
            left: screenWidth * 0.40,
            top: screenHeight * 0.25,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                //debugPrint("2ème touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true, // ✅ Ferme quand on clique à l'extérieur
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      content: const Text(
                        "Il n'y a rien dans cette cruche.",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.red.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          //3ème
          Positioned(
            right: screenWidth * 0.05,
            top: screenHeight * 0.25,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                //debugPrint("3ème touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true, // ✅ Ferme quand on clique à l'extérieur
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      content: const Text(
                        "Il n'y a rien dans cette jare.",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.yellow.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          //4ème
          Positioned(
            left: screenWidth * 0.20,
            top: screenHeight * 0.55,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                //debugPrint("4ème touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true, // ✅ Ferme quand on clique à l'extérieur
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      content: const Text(
                        "Il y a un bout de chiffon avec des runes dessus.\n"
                            "Prenez le parchemin avec des runes gravées dessus.",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.purple.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          //5ème
          Positioned(
            right: screenWidth * 0.18,
            top: screenHeight * 0.55,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                //debugPrint("5ème touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true, // ✅ Ferme quand on clique à l'extérieur
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      content: const Text(
                        "Il n'y a rien dans ce vase.",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.orange.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          // Bouton d’accès à l’inventaire (un peu plus haut)
          Positioned(
            bottom: 100, // ajusté
            right: 20,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.brown.shade600,
              icon: const Icon(Icons.inventory_2, color: Colors.white),
              label: const Text(
                "Inventaire",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InventairePage()),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Ligne supérieure : bouton retour + menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton retour (haut gauche)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Retour sans recréer la page
                        },
                      ),
                    ],
                  ),
                ),

                // ⏱️ Chronomètre
                const TimerButton(),

                const Spacer(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
