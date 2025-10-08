import 'package:flutter/material.dart';
import '../pages/home.dart';

class DevBackHomeButton extends StatelessWidget {
  const DevBackHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 12,
      child: GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Accueil',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}