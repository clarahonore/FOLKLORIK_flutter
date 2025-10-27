import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import '../../widgets/timer_button.dart';
import '../../services/accessibilite_status.dart';
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

  final AudioPlayer _buttonAudioPlayer = AudioPlayer();
  bool _buttonSoundPlayed = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    Timer(const Duration(seconds: 3), () {
      setState(() => _showButton = true);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleSortirCabane(BuildContext context, bool narrationActive) async {
    if (narrationActive && !_buttonSoundPlayed) {
      try {
        await _buttonAudioPlayer.stop();
        await _buttonAudioPlayer.setVolume(1.0);
        await _buttonAudioPlayer
            .setSource(AssetSource('audio/Sortir de la cabane.m4a'));
        await _buttonAudioPlayer.resume();
        setState(() => _buttonSoundPlayed = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appuyez encore pour sortir de la cabane..."),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint("Erreur audio bouton SORTIR DE LA CABANE : $e");
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Enigme1PortePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🌅 Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images_fond/cabane.png'),
                fit: BoxFit.cover,
                alignment: Alignment(0.3, 0.0),
              ),
            ),
          ),

          //Zone étagère
          Positioned(
            left: screenWidth * 0.25,
            top: screenHeight * 0.20,
            width: screenWidth * 0.20,
            height: screenHeight * 0.12,
            child: GestureDetector(
              onTap: () {
                debugPrint("Zone étagère touchée !");
              },
              child: Container(
                color: Colors.red.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          //Zone table
          Positioned(
            left: screenWidth * 0.22,
            top: screenHeight * 0.55,
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: GestureDetector(
              onTap: () {
                debugPrint("Zone table touchée !");
              },
              child: Container(
                color: Colors.blue.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          // Zone porte
          Positioned(
            right: screenWidth * 0.12,
            top: screenHeight * 0.40,
            width: screenWidth * 0.20,
            height: screenHeight * 0.35,
            child: GestureDetector(
              onTap: () => _handleSortirCabane(context, access.narrationActive),
              child: Container(
                color: Colors.green.withOpacity(0.3),
                //color: Colors.transparent,
              ),
            ),
          ),

          // Interface menu/timer..etc
          /*SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon:
                      const Icon(Icons.menu, size: 28, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
                const TimerButton(),
                const Spacer(),
              ],
            ),
          ),*/
          SafeArea(
            child: Column(
              children: [
                // 🔝 Ligne supérieure : bouton retour + menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔙 Bouton retour (haut gauche)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // ✅ Retour sans recréer la page
                        },
                      ),

                      // 🌙 Bouton menu (haut droite)
                      IconButton(
                        icon: const Icon(Icons.menu, size: 28, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // ⏱️ Chronomètre
                const TimerButton(),

                const Spacer(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
