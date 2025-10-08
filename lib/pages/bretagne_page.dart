import 'package:flutter/material.dart';

import 'enigme_1/intro_animation_enigme1.dart';
import 'package:mon_app/pages/home.dart';
import '../services/audio_service.dart';
//import 'intro_animation_enigme1.dart';

class BretagnePage extends StatefulWidget {
  const BretagnePage({super.key});

  @override
  State<BretagnePage> createState() => _BretagnePageState();

}

class _BretagnePageState extends State<BretagnePage> {
  /*final AudioService _stereo = AudioService();

  @override
  void initState() {
    super.initState();

    _stereo.playAsset("audio/audio_bretagne.mp3");
  }

  @override
  Future<void> dispose() async{

    super.dispose();
    await _stereo.stop();
  }

  Future<void> _initializeAudio() async {
    try{
      await Future.delayed(const Duration(milliseconds: 800));
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setVolume(0.85);

    } catch (e) {
      debugPrint("Erreur audio: $e");



  }
  */

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
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
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: screenHeight * 0.04 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BOUTON RETOUR À GAUCHE
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5E3C),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          "Retour",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // ICONE ACCESSIBILITÉ À DROITE
                      Column(
                        children: const [
                          Icon(Icons.visibility),
                          SizedBox(height: 4),
                          Text("Accessibilité", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
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
                        /*"Vous voilà en terre de Brocéliande, au cœur des brumes éternelles. "
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
                            "Et que la légende survive à travers vous. "

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
                            */

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


                  //Bouton Commencer
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