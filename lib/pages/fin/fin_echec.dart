import 'dart:async';
import 'package:flutter/material.dart';
import '../home.dart';

class FinEchecPage extends StatefulWidget {
  const FinEchecPage({super.key});

  @override
  State<FinEchecPage> createState() => _FinEchecPageState();
}

class _FinEchecPageState extends State<FinEchecPage>
    with TickerProviderStateMixin {
  late AnimationController _portalController;
  late AnimationController _fadeController;
  late Animation<double> _portalZoom;
  late Animation<double> _fadeToBlack;

  bool showPortal = false;
  bool showFinalText = false;

  @override
  void initState() {
    super.initState();

    _portalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _portalZoom = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _portalController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeToBlack = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    Timer(const Duration(seconds: 1), () {
      setState(() => showPortal = true);
      _portalController.forward();
    });

    Timer(const Duration(seconds: 5), () {
      _fadeController.forward();
    });

    Timer(const Duration(seconds: 8), () {
      setState(() => showFinalText = true);
    });

    Timer(const Duration(seconds: 14), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _portalController.dispose();
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
          Container(color: Colors.black),

            if (showPortal)
            AnimatedBuilder(
              animation: _portalController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _portalZoom.value,
                  child: Image.asset(
                    'assets/images/portail_fail.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

          if (_fadeController.value > 0)
            AnimatedBuilder(
              animation: _fadeToBlack,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(_fadeToBlack.value),
                );
              },
            ),

          if (showFinalText)
            Container(
              color: Colors.black,
              child: Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                  child: const Text(
                    "Malheureusement, le temps a manqué...\n\n"
                        "Vous n’avez pas réussi à sauver Merlin.\n\n"
                        "Mais l’histoire n’est pas finie —\nles Hauts-de-France vous attendent.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black,
                          offset: Offset(2, 2),
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