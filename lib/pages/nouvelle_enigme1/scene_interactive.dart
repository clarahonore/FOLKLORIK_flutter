import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../nouvelle_enigme1/scene_corbeau_enigme.dart';
import 'scene_serre_interactive.dart';
import '../enigme_1/reveil_enigme1.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/timer_button.dart';

class SceneInteractive extends StatefulWidget {
  const SceneInteractive({super.key});

  @override
  State<SceneInteractive> createState() => _SceneInteractiveState();
}

class _SceneInteractiveState extends State<SceneInteractive>
    with TickerProviderStateMixin {
  String _message = "";
  bool _animationsInitialized = false;

  late AnimationController _decorController;
  late AnimationController _calquesController;
  late Animation<double> _decorOpacity;
  late Animation<double> _oiseauOpacity;
  late Animation<double> _cabaneOpacity;
  late Animation<double> _serreOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    // 🕒 Démarre le timer global si ce n’est pas déjà fait
    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) {
        timer.start();
      }
    });
  }

  void _initAnimations() {
    _decorController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _calquesController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _decorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _decorController, curve: Curves.easeIn));

    _oiseauOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _calquesController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    _cabaneOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _calquesController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );

    _serreOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _calquesController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );

    _animationsInitialized = true;
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await _decorController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _calquesController.forward();
  }

  @override
  void dispose() {
    _decorController.dispose();
    _calquesController.dispose();
    super.dispose();
  }

  void _onTapCabane(BuildContext context) {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    // 🗝️ Si la cabane est déverrouillée, on entre
    if (inventory.cabaneDeverrouillee ||
        inventory.possedeObjet("Clé de la cabane")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReveilEnigme1()),
      );
    } else {
      setState(() {
        _message = "🚪 La porte semble verrouillée...";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_animationsInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.brown)),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Décor principal
          FadeTransition(
            opacity: _decorOpacity,
            child: Image.asset("assets/images/paysage.png", fit: BoxFit.cover),
          ),

          // 🕒 Timer global en haut à droite
          const TimerButton(),

          // 🏚️ Cabane (entrée possible si clé trouvée)
          Positioned(
            bottom: 310,
            right: 60,
            width: 260,
            child: GestureDetector(
              onTap: () => _onTapCabane(context),
              child: FadeTransition(
                opacity: _cabaneOpacity,
                child: Image.asset("assets/images/cabane.png"),
              ),
            ),
          ),

          // 🌿 Serre magique
          Positioned(
            bottom: 300,
            right: 320,
            width: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SceneSerreInteractive()),
                );
              },
              child: FadeTransition(
                opacity: _serreOpacity,
                child: Image.asset("assets/images/serre.png"),
              ),
            ),
          ),

          // 🐦 Corbeau sur la branche
          Positioned(
            bottom: 480,
            right: 150,
            width: 110,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SceneCorbeauEnigme()),
                );
              },
              child: FadeTransition(
                opacity: _oiseauOpacity,
                child: Image.asset("assets/images/oiseau.png"),
              ),
            ),
          ),

          // 💬 Message affiché temporairement
          if (_message.isNotEmpty)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
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