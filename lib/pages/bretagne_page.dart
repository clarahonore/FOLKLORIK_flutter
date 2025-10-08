import 'package:flutter/material.dart';
import 'package:mon_app/pages/home.dart';
import '../services/audio_service.dart';
import 'intro_animation_enigme1.dart';

class BretagnePage extends StatefulWidget {
  const BretagnePage({super.key});

  @override
  State<BretagnePage> createState() => _BretagnePageState();

}

class _BretagnePageState extends State<BretagnePage> {
  final AudioService _stereo = AudioService();

  @override
  void initState() {
    super.initState();

    _stereo.playAsset("audio/audio_bretagne.mp3");
  }

  @override
  void dispose() {
    _stereo.stop();
    super.dispose();
  }


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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BOUTON RETOUR À GAUCHE
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5E3C),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          "Retour",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // ICONE ACCESSIBILITÉ À DROITE
                      Column(
                        children: const [
                          Icon(Icons.visibility),
                          SizedBox(height: 4),
                          Text("Accessibilité", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/symbole-breton.png',
                        height: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "LE FOLKLORIK",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              "DE BRETAGNE",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.brown,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),


                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const Spacer(),

                  //Bouton Commencer
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const IntroAnimationEnigme1()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5E3C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "COMMENCER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ),


                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}