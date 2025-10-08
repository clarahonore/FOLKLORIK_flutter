import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'enigme_1/intro_animation_enigme1.dart';

class BretagnePage extends StatefulWidget {
  const BretagnePage({super.key});

  @override
  BretagnePageState createState() => BretagnePageState();
}

class BretagnePageState extends State<BretagnePage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      // 🕐 Laisse le moteur audio Android se préparer
      await Future.delayed(const Duration(milliseconds: 800));

      // 🔊 Mode de lecture haute qualité
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

      // 🎚️ Réduit un peu le volume pour éviter saturation et pertes
      await _audioPlayer.setVolume(0.85);

      // 🎵 Lecture du fichier audio
      await _audioPlayer.setSource(AssetSource('audio/bretagne.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Erreur audio : $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/parchemin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: const [
                        Icon(Icons.visibility),
                        SizedBox(height: 4),
                        Text("Accessibilité", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/symbole-breton.png',
                        height: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "LE FOLKLORIK",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              "DE BRETAGNE",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.brown,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // ✅ Texte déroulable
                  Expanded(
                    child: SingleChildScrollView(
                      child: const Text(
                        "Vous voilà en terre de Brocéliande, au cœur des brumes éternelles. "
                            "La forêt murmure des noms oubliés : Viviane, Morgane, Arthur… "
                            "Mais un silence inquiétant grandit : celui de Merlin. "
                            "La mémoire du grand enchanteur s’efface. "
                            "Chaque minute qui passe l’éloigne un peu plus du monde des vivants. "
                            "Si son souvenir disparaît, les contes et la magie bretonne sombreront avec lui. "
                            "Votre mission est claire : "
                            "retrouvez les fragments de mémoire disséminés dans la forêt, "
                            "puis préparez la potion de vitalité qui rendra sa conscience à Merlin. "
                            "Vous n’avez que 45 minutes avant que son nom ne s’efface à jamais. "
                            "Écoutez les fées, déchiffrez les runes, suivez les menhirs… "
                            "Et que la légende survive à travers vous. 🌿 "

                            "Vous voilà en Brocéliande. "
                            "Les arbres se penchent comme s’ils vous observaient. "
                            "L’air sent la mousse et la magie ancienne. "
                            "Mais quelque chose manque… "
                            "Une voix. "
                            "Une présence. "
                            "Merlin, le grand enchanteur, s’endort. "
                            "Son nom s’efface des mémoires. "
                            "Si vous ne faites rien, la Bretagne oubliera sa propre légende. "
                            "Vous n’avez que quarante-cinq minutes pour raviver son souvenir. "
                            "Trouvez les fragments de mémoire, "
                            "déchiffrez les runes, "
                            "suivez les menhirs, "
                            "et préparez la potion de vitalité qui lui rendra la parole. "

                            "Hâtez-vous, voyageurs… "
                            "car bientôt, même son nom ne résonnera plus. "


                            "Vous y voilà, vous etes arrivé en terre de Brocéliande, au cœur des brumes éternelles. "
                            "Autour de vous, les arbres se penchent comme si ’ils vous observaient et l’atmosphère sent la mousse et la magie ancienne de la fôret. "
                            "Le vent dans ces basses contrées murmure des noms oubliés tel Morgane, Arthur, Lancelot… "
                            "Mais un silence inquiétant grandit cependant. "
                            "Vous sentez dans ces murmure ’il manque quelque chose…ou plutôt quelqu’un… "
                            "La mémoire du grand enchanteur s’efface. Que dis je Merlin s’efface. "
                            "Si son souvenir disparaît, les contes et la magie sombreront et la Bretagne oubliera sa propre légende. "
                            "Vous n’avez que 45 min pour raviver son souvenir dans l’esprit de chacun. "
                            "Alors écoutez les fées, "
                            "déchiffrez les runes, "
                            "suivez les menhirs, "
                            "mais avant tout préparez la potion de vitalité qui sauvera Merlin de l’oubli. "

                            "Hâtez-vous, voyageurs du temps… "
                            "car bientôt, même son nom ne résonnera plus. "
                            "Que la légende survive à travers vous. ",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Bouton
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroAnimationEnigme1(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5E3C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "COMMENCER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
