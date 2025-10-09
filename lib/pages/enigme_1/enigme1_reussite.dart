import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../enigme_2/intro_pont_menhirs.dart';

class Enigme1Reussite extends StatefulWidget {
  const Enigme1Reussite({super.key});

  @override
  State<Enigme1Reussite> createState() => _Enigme1ReussiteState();
}

class _Enigme1ReussiteState extends State<Enigme1Reussite>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _fadeController;
  late AnimationController _textFadeController;

  late final AudioPlayer _audioPlayer; // 🎵 Audio au démarrage

  bool showPorteOuverte = false;
  bool showBlackScreen = false;

  @override
  void initState() {
    super.initState();

    // 🎵 Lancer l'audio dès l'ouverture de la page
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('audio/porte en bois.m4a'));

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 1.0,
      upperBound: 1.1,
    )..forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => showPorteOuverte = true);
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 4), () {
      setState(() => showBlackScreen = true);
      _fadeController.forward();

      Future.delayed(const Duration(seconds: 1), () {
        _textFadeController.forward();
      });
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IntroAnimationEnigme2()),
        );
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    _textFadeController.dispose();
    _audioPlayer.dispose(); // 🚨 Important pour libérer la ressource audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!showPorteOuverte)
            AnimatedBuilder(
              animation: _zoomController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomController.value,
                  child: Image.asset(
                    'assets/images/enigme1_poignet_de_porte.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

          if (showPorteOuverte && !showBlackScreen)
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: 1,
              child: Image.asset(
                'assets/images/enigme1_porte_ouverte.png',
                fit: BoxFit.cover,
              ),
            ),

          if (showBlackScreen)
            FadeTransition(
              opacity: _fadeController,
              child: Container(color: Colors.black),
            ),

          if (showBlackScreen)
            FadeTransition(
              opacity: _textFadeController,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "✨ Félicitations !\n\nVous avez réussi la première énigme.\n\nVous sortez de la cabane...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
