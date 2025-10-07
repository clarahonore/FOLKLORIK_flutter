import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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


                const Text(
                  "FOLKLORIK",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.brown,
                  ),
                ),
                const Text(
                  "Escape Game",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 60),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5E3C),
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/symbole-breton.png', height: 20),
                        const SizedBox(width: 10),
                        const Text(
                          "BRETAGNE",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _lockedButton("HAUT DE FRANCE"),

                _lockedButton("OCCITANIE"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lockedButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset('assets/images/cadenas.png', height: 20),
          ],
        ),
      ),
    );
  }
}