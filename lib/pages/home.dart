import 'package:flutter/material.dart';
import '../widgets/region_button.dart';
import '../widgets/locked_button.dart';
import 'bretagne_page.dart';

import '../widgets/locked_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/parchemin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      children: const [
                        Icon(Icons.visibility),
                        Text("Accessibilité", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                const Text(
                  "FOLKLORIK",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.brown,
                  ),
                ),
                const Text(
                  "Escape Game",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 60),

                // Bouton Bretagne cliquable
                RegionButton(
                  label: "Bretagne",
                  imagePath: 'assets/images/symbole-breton.png',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BretagnePage()),
                    );
                  },
                ),

                const LockedButton(label: "Haut de France"),
                const LockedButton(label: "Occitanie"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}