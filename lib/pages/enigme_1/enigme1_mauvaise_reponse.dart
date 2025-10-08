import 'dart:async';
import 'package:flutter/material.dart';
import 'enigme1_porte.dart';

class Enigme1MauvaiseReponse extends StatefulWidget {
  const Enigme1MauvaiseReponse({super.key});

  @override
  State<Enigme1MauvaiseReponse> createState() => _Enigme1MauvaiseReponseState();
}

class _Enigme1MauvaiseReponseState extends State<Enigme1MauvaiseReponse>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _textFadeController;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 1.0,
      upperBound: 1.1,
    )..forward();

    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _textFadeController.forward();
    });


    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Enigme1PortePage()),
      );
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
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

          FadeTransition(
            opacity: _textFadeController,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                color: Colors.black.withOpacity(0.5),
                child: const Text(
                  "La porte ne s’ouvre pas...\nCe n’est pas le bon mot...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 8, color: Colors.black),
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