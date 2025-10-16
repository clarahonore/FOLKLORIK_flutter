import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'reveil_enigme1.dart';

class IntroApres1erEnigme extends StatefulWidget {
  const IntroApres1erEnigme({super.key});

  @override
  State<IntroApres1erEnigme> createState() => _IntroApres1erEnigmeState();
}

class _IntroApres1erEnigmeState extends State<IntroApres1erEnigme>
    with TickerProviderStateMixin {
  late final AnimationController _zoomController;
  late final AudioPlayer _audioPlayer;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('audio/cabane_reveil.m4a'));

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..forward();

    Future.delayed(const Duration(seconds: 50), () {
      if (!hasNavigated) {
        hasNavigated = true;
        _audioPlayer.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ReveilEnigme1()),
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
      body: SizedBox.expand(
        child: ClipRect(
          child: AnimatedBuilder(
            animation: zoom,
            builder: (context, child) {
              return Transform.scale(
                scale: zoom.value,
                child: SizedBox.expand(
                  child: Image.asset(
                    'assets/images_fond/intro2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
