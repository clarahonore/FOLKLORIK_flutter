import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/pages/accessibilite_page.dart';
import 'package:mon_app/services/accessibilite_status.dart';
import 'enigme_1/intro_animation_enigme1.dart';
import 'home.dart';

class BretagnePage extends StatefulWidget {
  const BretagnePage({super.key});

  @override
  BretagnePageState createState() => BretagnePageState();
}

class BretagnePageState extends State<BretagnePage> {
  late final AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _audioInitialise = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    final access = context.read<AccessibiliteStatus>();
    if (access.sonActive && !_audioInitialise) {
      await _initializeAudio();
      _audioInitialise = true;
    }

    _audioPlayer.onPositionChanged.listen((pos) {
      _currentPosition = pos;
    });
  }

  Future<void> _initializeAudio() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setVolume(0.85);
      await _audioPlayer.setSource(AssetSource('audio/bretagne.mp3'));
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint("Erreur audio : $e");
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

    // ⚡ Gestion dynamique du son
    if (access.sonActive && !_isPlaying) {
      _audioPlayer.seek(_currentPosition);
      _audioPlayer.resume();
      _isPlaying = true;
    } else if (!access.sonActive && _isPlaying) {
      _audioPlayer.pause();
      _isPlaying = false;
    }

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Boutons Accueil + Accessibilité
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton Accueil
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(Icons.home, color: textColor),
                              const SizedBox(height: 4),
                              Text(
                                "Accueil",
                                style: TextStyle(fontSize: 12, color: textColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Bouton Accessibilité
                        GestureDetector(
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
                      ],
                    ),
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
                          children: [
                            Text(
                              "LE FOLKLORIK",
                              style: TextStyle(
                                fontSize: 28 * fontSizeFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              "DE BRETAGNE",
                              style: TextStyle(
                                fontSize: 24 * fontSizeFactor,
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        "Vous y voilà, vous êtes arrivés en terres de Brocéliande...",
                        style: TextStyle(
                          fontSize: 16 * fontSizeFactor,
                          height: 1.5,
                          color: textColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroAnimationEnigme1(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: access.contraste ? Colors.grey[800] : const Color(0xFF8B5E3C),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "COMMENCER",
                        style: TextStyle(
                          fontSize: 18 * fontSizeFactor,
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
