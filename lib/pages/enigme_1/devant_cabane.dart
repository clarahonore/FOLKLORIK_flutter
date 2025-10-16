import 'package:flutter/material.dart';
import 'package:mon_app/widgets/app_button.dart';
import 'package:mon_app/pages/enigme_1/intro_apres_1er_enigme.dart';

class devantcabane extends StatelessWidget {
  const devantcabane({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Center(
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
    );
  }
}
