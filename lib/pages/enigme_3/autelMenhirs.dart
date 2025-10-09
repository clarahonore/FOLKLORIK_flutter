import 'dart:ui';

import 'package:flutter/material.dart';
import '../../widgets/dev_back_home_button.dart';
import '../../widgets/timer_button.dart';
import '../enigme_4/intro_labo_druide.dart';

class autelMenhirPage extends StatefulWidget {
  const autelMenhirPage({super.key});

  @override
  State<autelMenhirPage> createState() => _AutelMenhirPageState();
}

class _AutelMenhirPageState extends State<autelMenhirPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool showSecondImage = false;
  bool showInstructions = false;

  final List<String> symbols = [
    'assets/images/fleur.png',
    'assets/images/feu.png',
    'assets/images/eau.png',
    'assets/images/vent.png',
    'assets/images/montagne.png',
  ];

  final List<String> correctOrder = [
    'assets/images/montagne.png',
    'assets/images/feu.png',
    'assets/images/vent.png',
    'assets/images/fleur.png',
    'assets/images/eau.png',
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

  void onSymbolTap(int index) {
    final firstEmptyIndex = chosenSymbols.indexOf(null);
    if (firstEmptyIndex == -1) return;
    setState(() {
      chosenSymbols[firstEmptyIndex] = symbols[index];
      disabled[index] = true;
    });

    // Vérification remplissage case
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

  void _checkOrder([VoidCallback? refreshPopup]) {
    if (chosenSymbols.every((s) => s != null)) {
      if (List.generate(chosenSymbols.length,
              (i) => chosenSymbols[i] == correctOrder[i])
          .every((e) => e)) {
        /*showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Bravo !"),
            content: Text("Vous avez trouvé la bonne combinaison !"),
          ),
        );*/
        _showSuccessPopup();
      } else {
        _shakeController.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            resetSymbols();
          });
          refreshPopup?.call(); // 🪄 force le rebuild de la popup
        });
      }
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
    if (mounted) Navigator.pop(context); // ferme popup
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroAnimationEnigme4()),
      );
    }
  }

  Future<void> _shakeError() async {
    _shakeController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));
    resetSymbols();
  }

  void _showPopupPoeme() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Center(
              child: Container(
                width: size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Poème hivernal",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "À travers les montagnes enneigées, un garçon s’éveilla. "
                            "Ses cheveux aux couleurs du feu virevoltent au vent frais du matin.\n\n"
                            "Dans son ascension néanmoins, il découvrit avec stupeur une rose étincelante "
                            "où la rosée se contemplait tel mille miroirs.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.5,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 40),

                      // 🧩 Cases vides du code
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
                                borderRadius: BorderRadius.circular(10),
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

                      // 🔹 Symboles à choisir
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(symbols.length, (index) {
                          return GestureDetector(
                            onTap: disabled[index]
                                ? null
                                : () {
                              setState(() {
                                final firstEmptyIndex =
                                chosenSymbols.indexOf(null);
                                if (firstEmptyIndex != -1) {
                                  chosenSymbols[firstEmptyIndex] =
                                  symbols[index];
                                  disabled[index] = true;
                                }
                              });
                              setStateDialog(() {});
                              if (!chosenSymbols.contains(null)) {
                                _checkOrder(() => setStateDialog(() {}));
                              }
                            },
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

                      const SizedBox(height: 40),

                      // 🔸 Bouton stylisé “Réinitialiser”
                      SizedBox(
                        width: 220,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              resetSymbols();
                            });
                            setStateDialog(() {});
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const RadialGradient(
                                center: Alignment(-0.3, -0.4),
                                radius: 1.2,
                                colors: [
                                  Color(0xFFBF8038),
                                  Color(0xFF593C1A),
                                ],
                                stops: [0.42, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(3, 4),
                                ),
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(-2, -2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            alignment: Alignment.center,
                            child: const Text(
                              "RÉINITIALISER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔸 Bouton stylisé “Fermer”
                      SizedBox(
                        width: 220,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const RadialGradient(
                                center: Alignment(-0.3, -0.4),
                                radius: 1.2,
                                colors: [
                                  Color(0xFFBF8038),
                                  Color(0xFF593C1A),
                                ],
                                stops: [0.42, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(3, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            alignment: Alignment.center,
                            child: const Text(
                              "FERMER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                  ? 'assets/images/autel_dessus.png'
                  : 'assets/images/autel.png',
              fit: BoxFit.cover,
            ),
          ),

          // Message de départ
          if (!showSecondImage)
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  "Cliquer pour avancer jusqu'à l'autel",
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

          // Instructions de l'énigme
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
                        "\u2728 Énigme 3 : Poème hivernal",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Voici un poème à déchiffrer, découvrez sa signification et résolvez l'énigme.",
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

          // Bouton info
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

          // ✅ Zone de clic centrale pour le popup
          if (showSecondImage && !showInstructions)
            Center(
              child: GestureDetector(
                onTap: _showPopupPoeme,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
