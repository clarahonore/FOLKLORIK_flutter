import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/widgets/app_button.dart';
import 'package:mon_app/pages/enigme_1/intro_apres_1er_enigme.dart';
import 'package:mon_app/pages/inventaire_page.dart';
import 'package:mon_app/services/inventory_service.dart';

class devantcabane extends StatelessWidget {
  const devantcabane({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryService>();

    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bienvenue devant ma cabane !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 40),

                  AppButton(
                    text: "Continuer l'aventure",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IntroApres1erEnigme(),
                        ),
                      );
                    },
                  ),
                ],
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


          // Bouton pour ajouter un objet test (plus bas)
          Positioned(
            bottom: 100,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                inventory.ajouterObjet(
                  "Goute d'eau",
                  "assets/images_enigme/eau.png",
                  "Une Goute d'eau.",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text("Une goute d'eau est ajoutée à l’inventaire 🔑"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Ramasser un objet"),
            ),
          ),
        ],
      ),
    );
  }
}
