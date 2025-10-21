import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import '../../widgets/timer_button.dart';
import '../../widgets/app_button.dart';
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
        await _buttonAudioPlayer.setSource(AssetSource('audio/Sortir de la cabane.m4a'));
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

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images_fond/enigme1_reveil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
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

                const TimerButton(),

                const Spacer(),


                if (_showButton)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Center(
                        child: AppButton(
                          text: "SORTIR DE LA CABANE",
                          onPressed: () =>
                              _handleSortirCabane(context, access.narrationActive),
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