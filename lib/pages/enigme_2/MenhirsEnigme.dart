import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/timer_button.dart';
import '../enigme_3/autelMenhirs.dart';
import '../home.dart';

class MenhirsEnigme extends StatefulWidget {
  const MenhirsEnigme({super.key});

  @override
  State<MenhirsEnigme> createState() => _Enigme2MenhirsPageState();
}

class _Enigme2MenhirsPageState extends State<MenhirsEnigme>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool showSecondImage = false;
  bool showInstructions = false;

  final List<String> symbols = [
    'assets/images_enigme/eau.png',
    'assets/images_enigme/feu.png',
    'assets/images_enigme/montagne.png',
    'assets/images_enigme/fleur.png',
    'assets/images_enigme/vent.png',
  ];

  final List<String> correctOrder = [
    'assets/images_enigme/eau.png',
    'assets/images_enigme/montagne.png',
    'assets/images_enigme/vent.png',
    'assets/images_enigme/feu.png',
    'assets/images_enigme/fleur.png',
  ];

  List<String?> chosenSymbols = List.filled(5, null);
  List<bool> disabled = List.filled(5, false);

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation =
        Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      showSecondImage = true;
      showInstructions = true;
    });
    _controller.stop();
  }

  void _closeInstructions() => setState(() => showInstructions = false);
  void _openInstructions() => setState(() => showInstructions = true);

  void onSymbolTap(int index) {
    final firstEmptyIndex = chosenSymbols.indexOf(null);
    if (firstEmptyIndex == -1) return;
    setState(() {
      chosenSymbols[firstEmptyIndex] = symbols[index];
      disabled[index] = true;
    });

    if (!chosenSymbols.contains(null)) {
      _checkOrder();
    }
  }

  void resetSymbols() {
    setState(() {
      chosenSymbols = List.filled(5, null);
      disabled = List.filled(5, false);
    });
  }

  Future<void> _checkOrder() async {
    final isCorrect = List.generate(5, (i) => chosenSymbols[i] == correctOrder[i])
        .every((e) => e == true);

    if (isCorrect) {
      _showSuccessPopup();
    } else {
      _shakeError();
    }
  }

  Future<void> _showSuccessPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            "Bravo ! Vous avez trouvé la bonne combinaison !",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 5));
    if (mounted) Navigator.pop(context);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const autelMenhirPage()),
      );
    }
  }

  Future<void> _shakeError() async {
    _shakeController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));
    resetSymbols();
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
                  ? 'assets/images_fond/cromlech.png'
                  : 'assets/images_fond/cromlech.png',
              fit: BoxFit.cover,
            ),
          ),

          if (!showSecondImage)
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  "Cliquer pour avancer jusqu'au cromlech",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          const TimerButton(),

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
                        "\u2728 Énigme 2 : Le bon ordre des choses",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Remettez les bons symboles dans le bon ordre (de droite à gauche).",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _closeInstructions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
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

          if (showSecondImage && !showInstructions)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        final dx = _shakeAnimation.value;
                        return Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          final symbol = chosenSymbols[index];
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: symbol != null
                                ? Image.asset(symbol, fit: BoxFit.contain)
                                : null,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: disabled[index]
                              ? null
                              : () => onSymbolTap(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  symbols[index],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                                if (disabled[index])
                                  BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: resetSymbols,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Réinitialiser",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          if (isDevMode)
            Positioned(
              bottom: 30,
              right: 30,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "Page suivante (Dev)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const autelMenhirPage()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}