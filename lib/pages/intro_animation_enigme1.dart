import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'bretagne_game.dart';

class IntroAnimationEnigme1 extends StatefulWidget {
  const IntroAnimationEnigme1({super.key});

  @override
  State<IntroAnimationEnigme1> createState() => _IntroAnimationEnigme1State();
}

class _IntroAnimationEnigme1State extends State<IntroAnimationEnigme1> with TickerProviderStateMixin {
  late final AnimationController _zoomController1;
  late final AnimationController _zoomController2;
  late final AnimationController _flashController;
  late final AudioPlayer _audioPlayer;

  bool showSecondImage = false;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('audio/intro_bretagne.mp3'));

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
          MaterialPageRoute(builder: (_) => const BretagneGamePage()),
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
    final Animation<double> zoom = Tween<double>(begin: 1.0, end: 1.1).animate(
      showSecondImage ? _zoomController2 : _zoomController1,
    );

    final Animation<double> flashOpacity = Tween<double>(begin: 0.0, end: 0.8).animate(
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
                      ? 'assets/images/intro2.png'
                      : 'assets/images/intro1.png',
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
        ],
      ),
    );
  }
}