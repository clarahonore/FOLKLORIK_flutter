import 'dart:ui';
import 'package:flutter/material.dart';
import '../nouvelle_enigme1/scene_interactive.dart';

class IntroArrivee extends StatefulWidget {
  const IntroArrivee({super.key});

  @override
  State<IntroArrivee> createState() => _IntroArriveeState();
}

class _IntroArriveeState extends State<IntroArrivee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _verticalMoveAnimation;
  late Animation<double> _horizontalShakeAnimation;

  bool _showSkip = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _blurAnimation = Tween<double>(begin: 25.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _verticalMoveAnimation = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _horizontalShakeAnimation = Tween<double>(begin: -10, end: 10)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showSkip = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _passerIntro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SceneInteractive()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_horizontalShakeAnimation.value, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FractionalTranslation(
                    translation: _verticalMoveAnimation.value,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          "assets/images/arrivee.png",
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _blurAnimation.value,
                            sigmaY: _blurAnimation.value,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          if (_showSkip)
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _passerIntro,
                child: const Text("Passer l’intro"),
              ),
            ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _passerIntro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continuer",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}