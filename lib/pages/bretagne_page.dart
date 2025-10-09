import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/pages/accessibilite_page.dart';
import 'package:mon_app/services/accessibilite_status.dart';
import 'package:mon_app/widgets/app_button.dart';
import 'enigme_1/intro_animation_enigme1.dart';
import 'home.dart';

class BretagnePage extends StatefulWidget {
  const BretagnePage({super.key});

  @override
  BretagnePageState createState() => BretagnePageState();
}

class BretagnePageState extends State<BretagnePage> {
  // 🎵 Audio principal
  late final AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _audioInitialise = false;

  // 🔊 Audio pour les boutons
  final AudioPlayer _buttonAudioPlayer = AudioPlayer();
  bool _buttonSoundPlayed = false;
  bool _accessibiliteSoundPlayed = false;
  bool _accueilSoundPlayed = false;

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

  // 🎧 Gestion des sons de boutons
  Future<void> _playButtonSound(String asset, VoidCallback action, bool narrationFlag) async {
    if (narrationFlag) {
      try {
        await _buttonAudioPlayer.stop();
        await _buttonAudioPlayer.setVolume(1.0);
        await _buttonAudioPlayer.setSource(AssetSource(asset));
        await _buttonAudioPlayer.resume();
      } catch (e) {
        debugPrint("Erreur audio bouton ($asset) : $e");
      }
    } else {
      action();
    }
  }

  // 🏁 Actions des boutons
  Future<void> _handleCommencer(BuildContext context, bool narrationActive) async {
    await _playButtonSound(
      'audio/Commencer.m4a',
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroAnimationEnigme1()),
      ),
      narrationActive,
    );
  }

  Future<void> _handleAccessibilite(BuildContext context, bool narrationActive) async {
    await _playButtonSound(
      'audio/Accessibilité.m4a',
          () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccessibilitePage()),
      ),
      narrationActive,
    );
  }

  Future<void> _handleAccueil(BuildContext context, bool narrationActive) async {
    await _playButtonSound(
      'audio/Accueil.m4a',
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ),
      narrationActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    // 🔊 Gestion du son principal selon accessibilité
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
          // 🧾 Fond parchemin
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
                  // 🧭 Boutons Accueil + Accessibilité
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

                  // 🪶 Titre
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

                  // 📜 Texte narratif
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

                  // 🔸 Bouton COMMENCER stylé
                  Center(
                    child: AppButton(
                      text: "COMMENCER",
                      onPressed: () => _handleCommencer(context, access.narrationActive),
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