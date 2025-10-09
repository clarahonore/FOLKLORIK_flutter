import 'dart:async';
import 'package:flutter/material.dart';
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

  bool showPorteOuverte = false;
  bool showBlackScreen = false;
  bool showNextButton = false;

  @override
  void initState() {
    super.initState();

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

    Future.delayed(const Duration(seconds: 4), () {
      setState(() => showBlackScreen = true);
      _fadeController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() => showNextButton = true);
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const IntroAnimationEnigme2()),
    );
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

          if (showNextButton && showPorteOuverte)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continuer vers l'Énigme 2",
                    style: TextStyle(
                      fontSize: 20,
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
