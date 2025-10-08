import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/audio_service.dart';
import '../widgets/region_button.dart';
import '../widgets/locked_button.dart';
import 'bretagne_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  final AudioService _stereo = AudioService();

  @override
  void initState() {
    super.initState();
    _stereo.playAsset("audio/audio_all_scenarios.mp3");
  }

  @override
  Future<void> dispose() async{

    super.dispose();
    await _stereo.stop();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      children: const [
                        Icon(Icons.visibility),
                        Text("Accessibilité", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                Text(
                  "FOLKLORIK",
                  style: GoogleFonts.podkova(
                    textStyle: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.brown,
                    ),
                  ),
                ),

                Text(
                  "Escape Game",
                  style: GoogleFonts.tiltPrism(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      color: Colors.brown,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                RegionButton(
                  label: "Bretagne",
                  imagePath: 'assets/images/symbole-breton.png',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BretagnePage()),
                    );
                  },
                ),

                const LockedButton(label: "Haut de France"),
                const LockedButton(label: "Occitanie"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}