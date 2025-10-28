import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/widgets/app_button.dart';
import 'package:mon_app/pages/enigme_1/intro_apres_1er_enigme.dart';
import 'package:mon_app/pages/inventaire_page.dart';
import 'package:mon_app/services/inventory_service.dart';
import '../../widgets/timer_button.dart';
import '../../services/accessibilite_status.dart';

class ChemineePage extends StatelessWidget {
  const ChemineePage({super.key});

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
                image: AssetImage('assets/images_fond/cheminee.png'),
                fit: BoxFit.cover,
                //alignment: Alignment(0.2, 0.0),
              ),
            ),
          ),

          //Zone étagère
          Positioned(
            left: screenWidth * 0.30,
            top: screenHeight * 0.15,
            width: screenWidth * 0.40,
            height: screenHeight * 0.20,
            child: GestureDetector(
              onTap: () {
                //debugPrint("Zone 1 touchée !");
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.brown[100]?.withOpacity(0.95),
                      title: const Center(
                        child: Text(
                          "Parchemin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: const Text(
                        "Un vieux parchemin est accroché ici... Peut-être qu'il nous sera utile.\n"
                            "Prenez le parchemin 1",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
                inventory.ajouterObjet(
                  "Carte environs",
                  "assets/images_enigme/parchemin.PNG",
                  "C'est une carte de la fôret qui entoure la cabane.",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text("La carte des environs est ajoutée à l’inventaire 🔑"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                //color: Colors.red.withOpacity(0.3),
                color: Colors.transparent,
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
