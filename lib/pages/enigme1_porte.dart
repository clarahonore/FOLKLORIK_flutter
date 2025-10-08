import 'package:flutter/material.dart';
import '../widgets/dev_back_home_button.dart';
import '../widgets/timer_button.dart';

class Enigme1PortePage extends StatefulWidget {
  const Enigme1PortePage({super.key});

  @override
  State<Enigme1PortePage> createState() => _Enigme1PortePageState();
}

class _Enigme1PortePageState extends State<Enigme1PortePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool showSecondImage = false;
  bool showInstructions = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      showSecondImage = true;
      showInstructions = true;
    });
    _controller.stop();
  }

  void _closeInstructions() {
    setState(() {
      showInstructions = false;
    });
  }

  void _openInstructions() {
    setState(() {
      showInstructions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: !showSecondImage ? _handleTap : null,
            child: Image.asset(
              showSecondImage
                  ? 'assets/images/porte_inscription_proche.png'
                  : 'assets/images/porte_inscription_loin.png',
              fit: BoxFit.cover,
            ),
          ),

          if (!showSecondImage)
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  "Cliquer pour avancer jusqu'à la porte",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.black),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          const TimerButton(),
          const DevBackHomeButton(),

          if (showSecondImage && showInstructions)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "\u2728 Énigme 1 : Trouver le code des runes",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Voici une description à changer : explore les symboles autour de la porte pour reconstituer le code sacré.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _closeInstructions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Passer à l'énigme",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (showSecondImage && !showInstructions)
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton(
                onPressed: _openInstructions,
                backgroundColor: Colors.brown,
                child: const Icon(Icons.info_outline),
              ),
            ),
        ],
      ),
    );
  }
}