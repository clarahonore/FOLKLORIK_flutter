import 'dart:async';
import 'package:flutter/material.dart';
import '../home.dart';

class FinAnimationPage extends StatefulWidget {
  const FinAnimationPage({super.key});

  @override
  State<FinAnimationPage> createState() => _FinAnimationPageState();
}

class _FinAnimationPageState extends State<FinAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _fadeController;
  late Animation<double> _zoomAnimation;
  late Animation<double> _fadeAnimation;

  bool showSecondImage = false;
  bool showBlackBackground = false;
  bool showFinalText = false;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );
    _zoomController.forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    Timer(const Duration(seconds: 5), () {
      setState(() => showSecondImage = true);
      _fadeController.forward();
    });

    Timer(const Duration(seconds: 9), () {
      setState(() {
        showBlackBackground = true;
        showFinalText = true;
      });
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
          AnimatedBuilder(
            animation: _zoomController,
            builder: (context, child) {
              return Transform.scale(
                scale: _zoomAnimation.value,
                child: Image.asset(
                  'assets/images/reapparition_merlin.png',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          if (showSecondImage)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/image_fin.png',
                fit: BoxFit.cover,
              ),
            ),

          if (showBlackBackground)
            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: 1.0,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showFinalText)
                          const Text(
                            "Bravo ! Vous avez réussi à sauver Merlin.\n\n"
                                "Il vous tend un sachet de lavande pour vous remercier\n"
                                "et vous porter chance sur votre route.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black),
                              ],
                            ),
                          ),
                        const SizedBox(height: 80),
                        const Text(
                          "FIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 6,
                          ),
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