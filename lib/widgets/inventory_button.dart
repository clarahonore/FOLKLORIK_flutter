import 'package:flutter/material.dart';

class InventoryButton extends StatelessWidget {
  const InventoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        heroTag: "inventaire_btn",
        onPressed: () => Navigator.pushNamed(context, '/inventaire'),
        child: const Icon(Icons.inventory_2, size: 30),
      ),
    );
  }
}