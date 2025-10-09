import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/timer_button.dart';
import '../../widgets/dev_back_home_button.dart';
import '../../widgets/app_button.dart';
import 'enigme1_porte.dart';

class ReveilEnigme1 extends StatefulWidget {
  const ReveilEnigme1({super.key});

  @override
  State<ReveilEnigme1> createState() => _ReveilEnigme1State();
}

class _ReveilEnigme1State extends State<ReveilEnigme1>
    with SingleTickerProviderStateMixin {
  bool _showButton = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 🎬 Animation de fondu pour le bouton
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // ⏳ Délai avant affichage du bouton
    Timer(const Duration(seconds: 3), () {
      setState(() => _showButton = true);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/enigme1_reveil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔹 Bouton menu (placeholder)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 28, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),

                // ⏳ Timer en haut
                const TimerButton(),

                const Spacer(),

                // 🏠 Bouton retour dev home
                const DevBackHomeButton(),

                // ✨ Bouton principal centré avec fondu
                if (_showButton)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Center(
                        child: AppButton(
                          text: "SORTIR DE LA CABANE",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Enigme1PortePage(),
                              ),
                            );
                          },
                        ),
                      ),
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