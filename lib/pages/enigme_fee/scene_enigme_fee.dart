import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/pages/nouvelle_enigme1/scene_serre_interactive.dart';
import '../../services/inventory_service.dart';
import '../../services/game_timer_service.dart';
import '../../widgets/inventory_button.dart';
import '../../widgets/timer_button.dart';
import 'scene_coffre_fee.dart';
import 'scene_source_viviane.dart';

class SceneEnigmeFee extends StatefulWidget {
  const SceneEnigmeFee({super.key});

  @override
  State<SceneEnigmeFee> createState() => _SceneEnigmeFeeState();
}

class _SceneEnigmeFeeState extends State<SceneEnigmeFee>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();

  bool _animationDebloquee = false;
  bool _animationLancee = false;
  bool _dejaAllerSource = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _playMelodie();

    Future.delayed(Duration.zero, () {
      final timer = GameTimerService();
      if (!timer.isRunning) timer.toggle();
    });

    _verifierConditions();
  }

  void _initAnimation() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  Future<void> _playMelodie() async {
    try {
      await _player.setSource(AssetSource("audio/melodie_fee.mp3"));
      await _player.setVolume(0.9);
      await _player.resume();
    } catch (e) {
      debugPrint("Erreur audio : $e");
    }
  }

  Future<void> _verifierConditions() async {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.eauPureRecuperee) {
      setState(() => _dejaAllerSource = true);
      return;
    }

    if (inventory.cleRecuperee && inventory.guiRecuperee) {
      setState(() => _animationDebloquee = true);

      await Future.delayed(const Duration(seconds: 2));
      _fadeController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _animationLancee = true);

      await Future.delayed(const Duration(seconds: 10));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SceneSourceViviane()),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/arbre_fee.png",
            fit: BoxFit.cover,
          ),

          const TimerButton(),

          const InventoryButton(),

          if (_dejaAllerSource)
            Positioned(
              top: 50,
              left: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SceneSerreInteractive()),
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Retour à la serre",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

          if (!_animationDebloquee && !_dejaAllerSource)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SceneCoffreFee()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Ouvrir le coffre",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          if (_animationDebloquee && !_dejaAllerSource)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) => Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Center(
                    child: _animationLancee
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/fee_face.png",
                          width: 260,
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "« Bravo, tu as trouvé la clé de la serre ! »\n\n"
                                "Tu vois la fleur dans la serre ? Tu auras besoin de ces graines.\n"
                                "Mais pour cela, il faut la plus pure de la forêt…\n\n"
                                "Suis-moi, je t’emmène !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}