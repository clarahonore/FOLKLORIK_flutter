import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home.dart'; // ⚠️ Vérifie le chemin correct vers HomePage

class IntroFolklorik extends StatefulWidget {
  const IntroFolklorik({super.key});

  @override
  State<IntroFolklorik> createState() => _IntroFolklorikState();
}

class _IntroFolklorikState extends State<IntroFolklorik> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _playIntroAudio();
  }

  Future<void> _playIntroAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/all_scénario.mp3'));
      await _audioPlayer.setVolume(0.9);
      await _audioPlayer.resume();

      // Le texte s’affiche en même temps que le son
      setState(() => _showText = true);

      // Quand l’audio se termine → animation de glissement vers HomePage
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          Navigator.of(context).pushReplacement(_createSlideRoute());
        }
      });
    } catch (e) {
      debugPrint("Erreur audio : $e");
      if (mounted) {
        Navigator.of(context).pushReplacement(_createSlideRoute());
      }
    }
  }

  // 🌀 Animation de glissement vers HomePage
  Route _createSlideRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // de droite vers gauche
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Fond d’écran parchemin
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/parchemin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✨ Texte centré avec fondu et scroll si nécessaire
          AnimatedOpacity(
            opacity: _showText ? 1.0 : 0.0,
            duration: const Duration(seconds: 2),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Text(
                    "Tout commença par un frisson, une vibration étrange, comme si le temps lui-même retenait son souffle. "
                        "Puis d'un seul coup, le sol vibra sous vos pieds et tout devint lumière. "
                        "En un instant, le présent s'effaça. "
                        "Vous vous sentez tomber sans fin à travers les siècles, dans un silence qui vous paraît interminable. "
                        "Et quand vos pieds touchent enfin la terre, le monde tel que vous le connaissiez s'est comme évaporé. "
                        "Le ciel vous semble plus proche, l'air plus dense, et chaque pierre semble vous observer. "
                        "Devant vous s'étend une terre oubliée où les pierres parlent encore et où la magie n'a jamais vraiment disparu. "
                        "En tendant un peu plus l'oreille, vous pensez entendre les pierres murmurer le vent chantant des mots anciens. "
                        "Un cercle lumineux apparaît alors devant vous. "
                        "Ce cercle ressemble fortement à un portail dans l'air. "
                        "En tendant l'oreille, vous entendez une voix grave et posée vous dire sur ces mots : Voyageur du temps, écoutez bien, peu à peu, les mythes et les légendes de notre pays s'effacent des mémoires humaines. "
                        "Si elles disparaissent, c'est l'âme même de la France qui s'éteindra. "
                        "Mais tout n'est pas perdu. "
                        "Vous avez été choisi et vous seul pouvez rétablir l'équilibre. "
                        "Emportés à travers le temps, vous êtes les gardiens d'un dernier et unique espoir. "
                        "Pour chaque département, une légende ou encore un esprit ancien vous y attend. "
                        "Alors traversez les portails, rallumez leur feu et surtout empêchez l'oubli de dévorer nos traditions avant qu'elle même ne s'éteigne. "
                        "Le premier portail s'ouvre à l'ouest, là où la brume rencontre la mer, la Bretagne. "
                        "Un nom là-bas s'efface lentement. "
                        "Un magicien hors pair connu pour sa puissance incommensurable. "
                        "Entrez dans le portail et que votre légende à vous, cher gardien, commence. "
                        "Sur ces mots, le cercle s'illumine d'une lueur verte et dorée. "
                        "Le vent porte une odeur de sel, de lande et de forêt. "
                        "Alors vous pressez d'y entrer et le portail se referme sous vos pieds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.brown[900],
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ⬇️ Bouton "Passer" en bas de l'écran
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _audioPlayer.stop(); // Arrête l'audio si en cours
                  Navigator.of(context).pushReplacement(_createSlideRoute());
                },
                child: const Text(
                  "Passer",
                  style: TextStyle(
                    fontSize: 16,
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
