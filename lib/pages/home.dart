import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/locked_button.dart';
import '../widgets/app_button.dart';
import 'bretagne_page.dart';
import 'accessibilite_page.dart';
import '../services/accessibilite_status.dart';
import '../widgets/voice_button.dart'; // en haut du fichier
import '../widgets/developpeurs_button.dart.dart';

bool isDevMode = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _bretagneNarrationPlayed = false;
  bool _accessibiliteSoundPlayed = false;

  Future<void> _playBretagneAccessAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/bretagne_access.m4a'));
      await _audioPlayer.setVolume(0.85);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Erreur audio Bretagne Access : $e");
    }
  }

  Future<void> _handleAccessibilite(BuildContext context, bool narrationActive) async {
    if (narrationActive && !_accessibiliteSoundPlayed) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.setSource(AssetSource('audio/Accessibilité.m4a'));
        await _audioPlayer.resume();
        setState(() => _accessibiliteSoundPlayed = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appuyez encore pour ouvrir les paramètres d'accessibilité..."),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint("Erreur audio bouton Accessibilité : $e");
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccessibilitePage()),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    final Color backgroundColor = access.contraste ? Colors.black : Colors.white;
    final Color textColor = access.contraste ? Colors.white : Colors.black87;
    final double fontSizeFactor = access.texteGrand ? 1.2 : 1.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Fond parchemin
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images_logo/parchemin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Ligne du haut avec le bouton développeur et accessibilité
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DeveloppeursButton(
                        onDevModeActivated: () {
                          setState(() {
                            isDevMode = true;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () => _handleAccessibilite(context, access.narrationActive),
                        child: Column(
                          children: [
                            Icon(Icons.visibility, color: textColor),
                            const SizedBox(height: 4),
                            Text("Accessibilité", style: TextStyle(fontSize: 12, color: textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),


                Stack(
                  children: [
                    Text(
                      "FOLKLORIK",
                      style: GoogleFonts.podkova(
                        textStyle: TextStyle(
                          fontSize: 48 * fontSizeFactor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2.8
                            ..color = const Color(0xFFBF8038),
                        ),
                      ),
                    ),
                    Text(
                      "FOLKLORIK",
                      style: GoogleFonts.podkova(
                        textStyle: TextStyle(
                          fontSize: 48 * fontSizeFactor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: const Color(0xFF3B240C),
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  "Escape Game",
                  style: GoogleFonts.tiltPrism(
                    textStyle: TextStyle(
                      fontSize: 20 * fontSizeFactor,
                      letterSpacing: 2,
                      color: const Color(0xFF8B5E3C),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTap: () async {
                      if (access.narrationActive && !_bretagneNarrationPlayed) {
                        await _playBretagneAccessAudio();
                        setState(() => _bretagneNarrationPlayed = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Appuyez encore pour entrer en Bretagne..."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BretagnePage()),
                        );
                      }
                    },
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const RadialGradient(
                          center: Alignment(-0.3, -0.4),
                          radius: 1.2,
                          colors: [
                            Color(0xFFBF8038),
                            Color(0xFF593C1A),
                          ],
                          stops: [0.42, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(3, 4),
                          ),
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images_logo/symbole-breton.png',
                            height: 30,
                            width: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "BRETAGNE",
                            style: GoogleFonts.podkova(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              shadows: const [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const LockedButton(label: "Haut de France"),
                const LockedButton(label: "Occitanie"),

                const SizedBox(height: 20),

                // Affiche le mode développeur si activé
                if (isDevMode)
                  const Text(
                    "Mode développeur actif 🔓",
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 40),
                const VoiceButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}