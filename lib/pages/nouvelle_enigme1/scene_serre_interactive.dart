import 'package:flutter/material.dart';
import '../enigme_fee/scene_fee_intro.dart';
import '../enigme_fee/scene_fee_intro.dart'; // ✅ on importe la scène de l’énigme de la fée

class SceneSerreInteractive extends StatefulWidget {
  const SceneSerreInteractive({super.key});

  @override
  State<SceneSerreInteractive> createState() => _SceneSerreInteractiveState();
}

class _SceneSerreInteractiveState extends State<SceneSerreInteractive>
    with TickerProviderStateMixin {
  String _message = "";

  late AnimationController _decorController;
  late AnimationController _calquesController;

  late Animation<double> _decorOpacity;
  late Animation<double> _feeOpacity;
  late Animation<double> _poigneeOpacity;
  late Animation<double> _fleurOpacity;

  bool _animationsInitialized = false;
  bool _fleurActive = false;
  bool _poigneeActive = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _decorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _calquesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _decorOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _decorController, curve: Curves.easeIn));

    _feeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _calquesController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _poigneeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _calquesController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _fleurOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _calquesController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
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

  void _onTapPoignee() {
    setState(() {
      _poigneeActive = !_poigneeActive;
      _fleurActive = false;
    });
  }

  void _onTapFee() {
    // 👉 redirection vers l’intro de l’énigme de la fée
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SceneFeeIntro()),
    );
  }

  void _resetFilters() {
    setState(() {
      _fleurActive = false;
      _poigneeActive = false;
    });
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
          // 🌄 Décor
          FadeTransition(
            opacity: _decorOpacity,
            child: Image.asset(
              "assets/images/serre_scene.png",
              fit: BoxFit.cover,
            ),
          ),

          // ✨ Fée
          Positioned(
            bottom: 163,
            left: 155,
            width: 340,
            child: GestureDetector(
              onTap: _onTapFee, // ✅ nouvelle redirection ici
              child: FadeTransition(
                opacity: _feeOpacity,
                child: Image.asset("assets/images/fee.png"),
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

          // 🔑 Poignée
          Positioned(
            bottom: 332,
            right: 158,
            width: 75,
            child: GestureDetector(
              onTap: _onTapPoignee,
              child: FadeTransition(
                opacity: _poigneeOpacity,
                child: Image.asset("assets/images/poignee.png"),
              ),
            ),
          ),

          // 🌑 Filtre noir + texte fleur
          if (_fleurActive)
            IgnorePointer(
              ignoring: false,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.75),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "« Je crois que c’est ce qui peut nous sauver…\nmais elle a l’air d’avoir besoin d’eau. »",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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

          // 🌑 Filtre noir + texte poignée
          if (_poigneeActive)
            IgnorePointer(
              ignoring: false,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.75),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "« Mince… elle est fermée. »",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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

          // 🔙 Bouton Retour
          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
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
                "Retour",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}