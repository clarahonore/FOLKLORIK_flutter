import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/inventory_button.dart';
import '../../widgets/timer_button.dart';
import '../enigme_fee/scene_fee_intro.dart';
import '../enigme_serre_corbeau/scene_interieur_serre.dart';
import '../nouvelle_enigme1/scene_interactive.dart';

class SceneSerreInteractive extends StatefulWidget {
  const SceneSerreInteractive({super.key});

  @override
  State<SceneSerreInteractive> createState() => _SceneSerreInteractiveState();
}

class _SceneSerreInteractiveState extends State<SceneSerreInteractive>
    with TickerProviderStateMixin {
  bool _animationsInitialized = false;
  bool _fleurActive = false;
  bool _poigneeActive = false;

  late AnimationController _decorController;
  late AnimationController _calquesController;
  late Animation<double> _decorOpacity;
  late Animation<double> _feeOpacity;
  late Animation<double> _poigneeOpacity;
  late Animation<double> _fleurOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) {
        timer.toggle();
      }
    });
  }

  void _initAnimations() {
    _decorController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _calquesController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _decorOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _decorController, curve: Curves.easeIn));
    _feeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _calquesController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );
    _poigneeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _calquesController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );
    _fleurOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _calquesController,
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

  void _onTapFleur() {
    setState(() {
      _fleurActive = !_fleurActive;
      _poigneeActive = false;
    });
  }

  void _onTapPoignee(BuildContext context) {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.serreDeverrouillee || inventory.possedeObjet("Clé ancienne")) {
      inventory.marquerSerreDeverrouillee();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SceneInterieurSerre()),
      );
    } else {
      setState(() {
        _poigneeActive = !_poigneeActive;
        _fleurActive = false;
      });
    }
  }

  void _onTapFee() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SceneFeeIntro()),
    );
  }

  void _onRetourCabane(BuildContext context) {
    // ✅ retour direct vers la scène principale
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SceneInteractive()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_animationsInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.brown)),
      );
    }

    // 🔒 On bloque la fée si le joueur a les Graines OU le Calice d’eau pure
    final inventory = context.watch<InventoryService>();
    final feeBloquee = inventory.possedeObjet("Graines magiques") ||
        inventory.possedeObjet("Calice d’eau pure");

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Décor
          FadeTransition(
            opacity: _decorOpacity,
            child: Image.asset(
              "assets/images/serre_scene.png",
              fit: BoxFit.cover,
            ),
          ),

          // ⏱️ Timer global en haut à droite
          const TimerButton(),

          // 🧚‍♀️ Fée (désactivée si déjà aidée)
          Positioned(
            bottom: 163,
            left: 155,
            width: 340,
            child: IgnorePointer(
              ignoring: feeBloquee,
              child: GestureDetector(
                onTap: feeBloquee ? null : _onTapFee,
                child: FadeTransition(
                  opacity: _feeOpacity,
                  child: Opacity(
                    opacity: feeBloquee ? 0.6 : 1.0,
                    child: Image.asset("assets/images/fee.png"),
                  ),
                ),
              ),
            ),
          ),

          // 🌸 Fleur
          Positioned(
            bottom: 214,
            right: 124,
            width: 260,
            child: GestureDetector(
              onTap: _onTapFleur,
              child: FadeTransition(
                opacity: _fleurOpacity,
                child: Image.asset("assets/images/fleur.png"),
              ),
            ),
          ),

          // 🔒 Poignée
          Positioned(
            bottom: 332,
            right: 158,
            width: 75,
            child: GestureDetector(
              onTap: () => _onTapPoignee(context),
              child: FadeTransition(
                opacity: _poigneeOpacity,
                child: Image.asset("assets/images/poignee.png"),
              ),
            ),
          ),

          // 💬 Texte Fleur
          if (_fleurActive)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _fleurActive = false),
                child: Container(
                  color: Colors.black.withOpacity(0.75),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "« Je crois que c’est ce qui peut nous sauver…\nmais elle a l’air d’avoir besoin d’eau. »",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (_poigneeActive)
          Positioned.fill(
          child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() =>  _poigneeActive = false),
          child:  Container(
              color: Colors.black.withOpacity(0.75),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "« Mince… elle est fermée. »",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),

          const InventoryButton(),

          // 🔙 Bouton retour → SceneInteractive
          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () => _onRetourCabane(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_back, size: 22),
              label: const Text(
                "Retour à la cabane",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}