import 'package:flutter/material.dart';
import '../../widgets/timer_button.dart';
import '../../widgets/app_button.dart';
import 'package:audioplayers/audioplayers.dart';
import '../home.dart';
import '../enigme_2/intro_pont_menhirs.dart';

class Enigme1PortePage extends StatefulWidget {
  const Enigme1PortePage({super.key});

  @override
  State<Enigme1PortePage> createState() => _Enigme1PortePageState();
}

class _Enigme1PortePageState extends State<Enigme1PortePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  final TextEditingController _controllerText = TextEditingController();

  bool showSecondImage = false;
  bool showInstructions = false;

  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerText.dispose();
    _audioPlayer.dispose();
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

  void _checkAnswer() {
    final input = _controllerText.text.trim().toLowerCase();
    if (input == 'source viviane') {
      Navigator.pushReplacementNamed(context, '/enigme1_reussite');
    } else {
      Navigator.pushReplacementNamed(context, '/enigme1_echec');
    }
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
                  ? 'assets/images_fond/porte_inscription_proche.png'
                  : 'assets/images_fond/porte_inscription_loin.png',
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
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // ⏱️ Bouton du timer
          const Positioned(
            top: 40,
            right: 30,
            child: TimerButton(),
          ),

          if (showSecondImage && showInstructions)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
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
                        "Explore les symboles autour de la porte pour reconstituer le code sacré.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: "Passer à l'énigme",
                        onPressed: _closeInstructions,
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
                padding:
                const EdgeInsets.only(bottom: 80.0, left: 24.0, right: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controllerText,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Entrez le mot de passe...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: "Valider",
                      onPressed: _checkAnswer,
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
                  _audioPlayer.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const IntroAnimationEnigme2()),
                  );
                },
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // Ligne supérieure : bouton retour + menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton retour (haut gauche)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Retour sans recréer la page
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
