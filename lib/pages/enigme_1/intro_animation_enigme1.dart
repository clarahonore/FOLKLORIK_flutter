import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/game_timer_service.dart';
import 'devant_cabane.dart';
import '../home.dart';

class IntroAnimationEnigme1 extends StatefulWidget {
  const IntroAnimationEnigme1({super.key});

  @override
  State<IntroAnimationEnigme1> createState() => _IntroAnimationEnigme1State();
}

class _IntroAnimationEnigme1State extends State<IntroAnimationEnigme1>
    with TickerProviderStateMixin {
  late final AnimationController _zoomController;
  late final AudioPlayer _audioPlayer;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Démarre le chrono du jeu
    GameTimerService().start();

    // Joue le son
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('audio/cabane_reveil.m4a'));

    // Animation du zoom
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..forward();

    // Redirection automatique
    Future.delayed(const Duration(seconds: 15), () {
      if (!hasNavigated) {
        hasNavigated = true;
        _audioPlayer.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const devantcabane()),
        );
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zoom = Tween<double>(begin: 1.0, end: 1.15).animate(_zoomController);

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Image plein écran avec zoom
          SizedBox.expand(
            child: ClipRect(
              child: AnimatedBuilder(
                animation: zoom,
                builder: (context, child) {
                  return Transform.scale(
                    scale: zoom.value,
                    child: SizedBox.expand(
                      child: Image.asset(
                        'assets/images_fond/intro1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ Bouton développeur visible uniquement si isDevMode = true
          if (isDevMode)
            Positioned(
              bottom: 30,
              right: 30,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "Page suivante (Dev)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const devantcabane()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
