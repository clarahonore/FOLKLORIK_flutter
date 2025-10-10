import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../../services/game_timer_service.dart';
import '../../services/accessibilite_status.dart';
import 'MenhirsEnigme.dart';

class IntroAnimationEnigme2 extends StatefulWidget {
  const IntroAnimationEnigme2({super.key});

  @override
  State<IntroAnimationEnigme2> createState() => _IntroAnimationEnigme2State();
}

class _IntroAnimationEnigme2State extends State<IntroAnimationEnigme2>
    with TickerProviderStateMixin {
  late final AnimationController _zoomController1;
  late final AnimationController _zoomController2;
  late final AnimationController _flashController;

  late final AudioPlayer _audioBois;
  late final AudioPlayer _audioVent;

  bool showSecondImage = false;
  bool hasNavigated = false;
  bool _audioPlaying = false;

  @override
  void initState() {
    super.initState();

    GameTimerService().start();

    _audioBois = AudioPlayer();
    _audioVent = AudioPlayer();


    _zoomController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();

    _zoomController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );


    Future.delayed(const Duration(seconds: 8), () async {
      await _flashController.forward();
      setState(() => showSecondImage = true);
      _zoomController2.forward();
      await _flashController.reverse();
    });


    Future.delayed(const Duration(seconds: 16), () {
      if (!hasNavigated) {
        hasNavigated = true;
        _stopAllAudio();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MenhirsEnigme()),
        );
      }
    });
  }

  //Joue un son en boucle
  Future<void> _playLoopingAudio(AudioPlayer player, String path) async {
    try {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setSource(AssetSource(path));
      await player.setVolume(0.8);
      await player.resume();
    } catch (e) {
      debugPrint("Erreur lors de la lecture de $path : $e");
    }
  }


  Future<void> _stopAllAudio() async {
    await _audioBois.stop();
    await _audioVent.stop();
    _audioPlaying = false;
  }


  Future<void> _updateAudio(bool sonActif) async {
    if (sonActif && !_audioPlaying) {
      _audioPlaying = true;
      await _playLoopingAudio(_audioBois, 'audio/déplacement dans les bois.mp3');

    } else if (!sonActif && _audioPlaying) {
      await _stopAllAudio();
    }
  }

  @override
  void dispose() {
    _zoomController1.dispose();
    _zoomController2.dispose();
    _flashController.dispose();
    _stopAllAudio();
    _audioBois.dispose();
    _audioVent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    // Vérifie l’état du son
    _updateAudio(access.sonActive);

    final zoom = Tween<double>(begin: 1.0, end: 1.1).animate(
      showSecondImage ? _zoomController2 : _zoomController1,
    );

    final flashOpacity = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: zoom,
            builder: (context, child) {
              return Transform.scale(
                scale: zoom.value,
                child: Image.asset(
                  showSecondImage
                      ? 'assets/images/cromlech.png'
                      : 'assets/images/pont.png',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: flashOpacity,
            builder: (context, child) {
              return Container(
                color: Colors.white.withOpacity(flashOpacity.value),
              );
            },
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () async {
                  if (!hasNavigated) {
                    hasNavigated = true;
                    await _stopAllAudio();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MenhirsEnigme()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Passer Scène',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
