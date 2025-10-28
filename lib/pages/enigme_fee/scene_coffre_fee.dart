import 'package:flutter/material.dart';
import 'package:mon_app/pages/enigme_fee/scene_enigme_fee.dart';
import 'package:provider/provider.dart';
import '../../services/inventory_service.dart';
import '../../widgets/inventory_button.dart';

class SceneCoffreFee extends StatefulWidget {
  const SceneCoffreFee({super.key});

  @override
  State<SceneCoffreFee> createState() => _SceneCoffreFeeState();
}

class _SceneCoffreFeeState extends State<SceneCoffreFee>
    with TickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final String _goodCode = "1342";
  String? _message;

  bool _unlocked = false;
  bool _showCoffreOuvert = false;
  bool _showInterieur = false;
  bool _showCle = false;
  bool _showGui = false;
  bool _cleRecuperee = false;
  bool _guiRecuperee = false;

  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 🧠 Vérifie l’état du scénario global
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inventory = Provider.of<InventoryService>(context, listen: false);
      if (inventory.coffreOuvert) {
        setState(() {
          _unlocked = true;
          _showInterieur = true;
          _showCle = !inventory.cleRecuperee;
          _showGui = !inventory.guiRecuperee;
          _cleRecuperee = inventory.cleRecuperee;
          _guiRecuperee = inventory.guiRecuperee;
        });
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _checkCode() async {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.coffreOuvert) return;

    if (_codeController.text == _goodCode) {
      inventory.marquerCoffreOuvert();
      setState(() => _message = "✨ Le coffre s’ouvre lentement…");

      await _fadeController.forward();
      setState(() => _unlocked = true);
      await Future.delayed(const Duration(milliseconds: 400));
      await _fadeController.reverse();

      setState(() => _showCoffreOuvert = true);
      _zoomController.forward();

      await Future.delayed(const Duration(seconds: 2));

      await _fadeController.forward();
      setState(() {
        _showInterieur = true;
        _showCoffreOuvert = false;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      await _fadeController.reverse();

      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _showCle = true;
        _showGui = true;
      });
    } else {
      setState(() =>
      _message = "❌ Ce n’est pas le bon code... Écoute bien la mélodie.");
    }
  }

  Future<void> _recupererCle() async {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.cleRecuperee) return;

    inventory.ajouterObjet(
      "Clé ancienne",
      "assets/images/cle_fee.png",
      "Une clé dorée trouvée dans le coffre des fées. Elle semble ouvrir la cabane.",
    );
    inventory.marquerCleRecuperee();

    setState(() {
      _showCle = false;
      _cleRecuperee = true;
      _message = "🔑 Vous avez récupéré la clé !";
    });
  }

  Future<void> _recupererGui() async {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    if (inventory.guiRecuperee) return;

    inventory.ajouterObjet(
      "Branche de gui",
      "assets/images/branche_gui.png",
      "Une branche de gui sacrée, symbole de protection et de chance.",
    );
    inventory.marquerGuiRecuperee();

    setState(() {
      _showGui = false;
      _guiRecuperee = true;
      _message = "🌿 Vous avez ramassé une branche de gui !";
    });
  }

  void _retourEnigmeFee() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SceneEnigmeFee()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🧳 Coffre fermé
          if (!_unlocked)
            Image.asset("assets/images/coffre_fee.png", fit: BoxFit.cover),

          // 🗝 Coffre ouvert (zoom)
          if (_showCoffreOuvert)
            AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomAnimation.value,
                  child: Image.asset("assets/images/coffre_ouvert.png",
                      fit: BoxFit.cover),
                );
              },
            ),

          // 📦 Intérieur du coffre
          if (_showInterieur)
            Image.asset("assets/images/interieur_coffre.png",
                fit: BoxFit.cover),

          // 🗝 Clé à récupérer
          if (_showCle)
            Positioned(
              bottom: 310,
              right: 160,
              width: 180,
              child: GestureDetector(
                onTap: _recupererCle,
                child: Image.asset("assets/images/cle_fee.png"),
              ),
            ),

          // 🌿 Branche de gui à récupérer
          if (_showGui)
            Positioned(
              bottom: 320,
              right: 40,
              width: 160,
              child: GestureDetector(
                onTap: _recupererGui,
                child: Image.asset("assets/images/branche_gui.png"),
              ),
            ),

          // 🔢 Entrée du code
          if (!_unlocked)
            IgnorePointer(
              ignoring: _fadeController.value > 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 180,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _codeController,
                      autofocus: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 28, letterSpacing: 6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: "----",
                        hintStyle:
                        TextStyle(color: Colors.white54, fontSize: 26),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _checkCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                    ),
                    child: const Text("Valider le code"),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),

          // 💬 Message
          if (_message != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, height: 1.5),
                  ),
                ),
              ),
            ),

          // 🌑 Fondu noir
          IgnorePointer(
            ignoring: true,
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) => Opacity(
                opacity: _fadeController.value,
                child: Container(color: Colors.black),
              ),
            ),
          ),

          // ✅ Confirmation clé ou gui récupérée
          if (_cleRecuperee || _guiRecuperee)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: 1,
                  child: Text(
                    _cleRecuperee && _guiRecuperee
                        ? "Vous avez tout récupéré !"
                        : _cleRecuperee
                        ? "Vous avez récupéré la clé !"
                        : "Vous avez ramassé le gui !",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 🔙 Bouton retour (visible quand coffre ouvert)
          if (_showInterieur)
            Positioned(
              bottom: 40,
              left: 20,
              child: ElevatedButton.icon(
                onPressed: _retourEnigmeFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back, size: 22),
                label: const Text(
                  "Retour",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          // 🎒 Inventaire global
          const InventoryButton(),
        ],
      ),
    );
  }
}