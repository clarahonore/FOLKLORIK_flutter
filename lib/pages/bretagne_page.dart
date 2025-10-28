import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accessibilite_page.dart';
import '../services/accessibilite_status.dart';
import '../widgets/app_button.dart';
import 'home.dart';
import 'nouvelle_enigme1/arrivee.dart';

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
      debugPrint("Erreur audio : $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _buttonAudioPlayer.dispose();
    super.dispose();
  }

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
        MaterialPageRoute(builder: (context) => const IntroArrivee()),
      );
    }
  }

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.libreBaskervilleTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images_logo/parchemin.png'),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images_logo/symbole-breton.png', height: 50),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LE FOLKLORIK",
                                style: GoogleFonts.podkova(
                                  fontSize: 28 * fontSizeFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                "DE BRETAGNE",
                                style: GoogleFonts.podkova(
                                  fontSize: 26 * fontSizeFactor,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFBF8038),
                                  letterSpacing: 1.5,
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
                          "Vous y voilà, vous êtes arrivés en terres de Brocéliande, au cœur des brumes éternelles. "
                              "Autour de vous, les arbres se penchent comme s'ils vous observaient de près. "
                              "L'atmosphère sent la mousse et la magie ancienne de la forêt. "
                              "Le vent murmure des noms oubliés : Morgane, Arthur, Lancelot... "
                              "Mais dans ces murmures, un silence inquiétant grandit. "
                              "La mémoire du grand enchanteur s'efface. Merlin s'efface. "
                              "Et si son souvenir disparaît, la magie sombrera, "
                              "et la Bretagne oubliera sa propre légende. "
                              "Vous n'avez que 45 minutes pour raviver son souvenir avant qu'il ne soit trop tard.",
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
      ),
    );
  }
}