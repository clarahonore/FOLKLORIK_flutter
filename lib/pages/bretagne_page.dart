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
  //  Audio principal
  late final AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _audioInitialise = false;

  //  Audio des boutons
  final AudioPlayer _buttonAudioPlayer = AudioPlayer();
  bool _buttonSoundPlayed = false; // COMMENCER
  bool _accessibiliteSoundPlayed = false; // ACCESSIBILITÉ
  bool _accueilSoundPlayed = false; // ACCUEIL 👈 nouveau

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
      debugPrint("Erreur audio principal : $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _buttonAudioPlayer.dispose();
    super.dispose();
  }

  // Bouton COMMENCER
  Future<void> _handleCommencer(BuildContext context, bool narrationActive) async {
    if (narrationActive && !_buttonSoundPlayed) {
      try {
        await _buttonAudioPlayer.stop();
        await _buttonAudioPlayer.setVolume(1.0);
        await _buttonAudioPlayer.setSource(AssetSource('audio/Commencer.m4a'));
        await _buttonAudioPlayer.resume();
        setState(() => _buttonSoundPlayed = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appuyez encore pour commencer..."),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint("Erreur audio COMMENCER : $e");
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroAnimationEnigme1()),
      );
    }
  }

  //Bouton ACCESSIBILITÉ
  Future<void> _handleAccessibilite(BuildContext context, bool narrationActive) async {
    if (narrationActive && !_accessibiliteSoundPlayed) {
      try {
        await _buttonAudioPlayer.stop();
        await _buttonAudioPlayer.setVolume(1.0);
        await _buttonAudioPlayer.setSource(AssetSource('audio/Accessibilité.m4a'));
        await _buttonAudioPlayer.resume();
        setState(() => _accessibiliteSoundPlayed = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appuyez encore pour ouvrir l'accessibilité..."),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint("Erreur audio ACCESSIBILITÉ : $e");
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccessibilitePage()),
      );
    }
  }

  // Bouton ACCUEIL
  Future<void> _handleAccueil(BuildContext context, bool narrationActive) async {
    if (narrationActive && !_accueilSoundPlayed) {
      try {
        await _buttonAudioPlayer.stop();
        await _buttonAudioPlayer.setVolume(1.0);
        await _buttonAudioPlayer.setSource(AssetSource('audio/Accueil.m4a'));
        await _buttonAudioPlayer.resume();
        setState(() => _accueilSoundPlayed = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appuyez encore pour revenir à l'accueil..."),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint("Erreur audio ACCUEIL : $e");
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    // Gestion du son principal
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
          // Fond parchemin
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

                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ACCUEIL
                        GestureDetector(
                          onTap: () => _handleAccueil(context, access.narrationActive),
                          child: Column(
                            children: [
                              Icon(Icons.home, color: textColor),
                              const SizedBox(height: 4),
                              Text("Accueil", style: TextStyle(fontSize: 12, color: textColor)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // ACCESSIBILITÉ
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
                  const SizedBox(height: 40),

                  // Titre
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/symbole-breton.png', height: 50),
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

                  // Texte principal
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        "Vous y voilà, vous êtes arrivés en terres de Brocéliande, au cœur des brumes éternelles. "
                            "Autour de vous, les arbres se penchent comme s'ils vous observaient de près. "
                            "Et l'atmosphère sent la mousse et la magie ancienne de la forêt. "
                            "Le vent murmure des noms oubliés à vos oreilles : Morgane, Arthur, Lancelot... "
                            "Mais dans ces murmures, un silence inquiétant grandit. "
                            "La mémoire du grand enchanteur s'efface... Merlin s'efface. "
                            "Et si son souvenir disparaît, les contes et la magie sombreront, "
                            "et la Bretagne oubliera sa propre légende. "
                            "Vous n'avez que 45 minutes pour raviver son souvenir avant qu'il ne soit trop tard. "
                            "Écoutez les fées déchiffrer les runes, suivez les menhirs, "
                            "et préparez la potion de vitalité qui sauvera Merlin de l'oubli. "
                            "Que la légende survive à travers vous... et surtout, bonne chance !",
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

                  // Bouton COMMENCER
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _handleCommencer(context, access.narrationActive),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        access.contraste ? Colors.grey[800] : const Color(0xFF8B5E3C),
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
