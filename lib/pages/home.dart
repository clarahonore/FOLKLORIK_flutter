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
  /*final AudioService _stereo = AudioService();

  @override
  void initState() {
    super.initState();
    _stereo.playAsset("audio/audio_all_scenarios.mp3");
  }

  @override
  Future<void> dispose() async{

    super.dispose();
    await _stereo.stop();
  }*/

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
            child:  SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: const [
                          Icon(Icons.visibility),
                          Text("Accessibilité", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08, width: screenWidth * 0.02),

                  Text(
                    "FOLKLORIK",
                    style: GoogleFonts.podkova(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.brown,
                      ),
                    ),
                  ),

                  Text(
                    "Escape Game",
                    style: GoogleFonts.tiltPrism(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.05,
                        letterSpacing: 2,
                        color: Colors.brown,
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  SizedBox(
                    width: screenWidth * 0.7,
                    child: RegionButton(
                      label: "Bretagne",
                      imagePath: 'assets/images/symbole-breton.png',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BretagnePage()),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                      width: screenWidth * 0.7,
                      child: const LockedButton(
                          label: "Haut de France")
                  ),

                  SizedBox(
                    width: screenWidth * 0.7,
                      child: const LockedButton(
                          label: "Occitanie")
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}