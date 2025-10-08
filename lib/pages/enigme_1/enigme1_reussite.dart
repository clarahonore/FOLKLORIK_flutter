import 'dart:async';
import 'package:flutter/material.dart';

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

    //  Redirection désactivée pour le moment
    // Future.delayed(const Duration(seconds: 6), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const SuivantPage()),
    //   );
    // });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
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
        ],
      ),
    );
  }
}