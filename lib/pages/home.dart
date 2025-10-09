import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/region_button.dart';
import '../widgets/locked_button.dart';
import 'bretagne_page.dart';
import 'accessibilite_page.dart';
import '../services/accessibilite_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _bretagneNarrationPlayed = false;

  Future<void> _playBretagneAccessAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/bretagne_access.mp3'));
      await _audioPlayer.setVolume(0.85);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Erreur audio Bretagne Access : $e");
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

                // Bouton Accessibilité
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccessibilitePage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Icon(Icons.visibility, color: textColor),
                          const SizedBox(height: 4),
                          Text(
                            "Accessibilité",
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // Titres
                Text(
                  "FOLKLORIK",
                  style: GoogleFonts.podkova(
                    textStyle: TextStyle(
                      fontSize: 48 * fontSizeFactor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Text(
                  "Escape Game",
                  style: GoogleFonts.tiltPrism(
                    textStyle: TextStyle(
                      fontSize: 20 * fontSizeFactor,
                      letterSpacing: 2,
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Bouton Bretagne avec narration
                RegionButton(
                  label: "Bretagne",
                  imagePath: 'assets/images/symbole-breton.png',
                  onPressed: () async {
                    if (access.narrationActive && !_bretagneNarrationPlayed) {
                      // Premier clic : joue l'audio narration
                      await _playBretagneAccessAudio();
                      setState(() => _bretagneNarrationPlayed = true);
                    } else {
                      // Deuxième clic ou si narration désactivée : ouvre la page Bretagne
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BretagnePage(),
                        ),
                      );
                    }
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
