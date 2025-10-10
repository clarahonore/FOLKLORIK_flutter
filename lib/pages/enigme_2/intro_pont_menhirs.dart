import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/game_timer_service.dart';
import 'MenhirsEnigme.dart';

class IntroAnimationEnigme2 extends StatefulWidget {
  const IntroAnimationEnigme2({super.key});

  @override
  State<IntroAnimationEnigme2> createState() => _IntroAnimationEnigme1State();
}

class _IntroAnimationEnigme1State extends State<IntroAnimationEnigme2> with TickerProviderStateMixin {
  late final AnimationController _zoomController1;
  late final AnimationController _zoomController2;
  late final AnimationController _flashController;
  late final AudioPlayer _audioPlayer;

  bool showSecondImage = false;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    GameTimerService().start();

    //_audioPlayer = AudioPlayer();
    //_audioPlayer.play(AssetSource('audio/intro_bretagne.mp3'));

    _zoomController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();

    _zoomController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    Future.delayed(const Duration(seconds: 8), () async {
      await _flashController.forward();
      setState(() => showSecondImage = true);
      _zoomController2.forward();
      await _flashController.reverse();
    });

    Future.delayed(const Duration(seconds: 16), () {
      if (!hasNavigated) {
        hasNavigated = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MenhirsEnigme()),
        );
      }
    });
  }

  @override
  void dispose() {
    _zoomController1.dispose();
    _zoomController2.dispose();
    _flashController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zoom = Tween<double>(begin: 1.0, end: 1.1).animate(
      showSecondImage ? _zoomController2 : _zoomController1,
    );

    final flashOpacity = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: zoom,
            builder: (context, child) {
              return Transform.scale(
                scale: zoom.value,
                child: Image.asset(
                  showSecondImage
                      ? 'assets/images/cromlech.png'
                      : 'assets/images/pont.png',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: flashOpacity,
            builder: (context, child) {
              return Container(
                color: Colors.white.withOpacity(flashOpacity.value),
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () async {
                  if (!hasNavigated) {
                    hasNavigated = true;
                    await _audioPlayer.stop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MenhirsEnigme()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Passer Scène',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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