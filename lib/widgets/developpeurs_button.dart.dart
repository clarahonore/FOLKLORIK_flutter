import 'package:flutter/material.dart';

class DeveloppeursButton extends StatefulWidget {
  final ValueChanged<bool> onDevModeChanged; // bool -> true = activé, false = désactivé
  final bool isDevMode; // état actuel du mode développeur

  const DeveloppeursButton({
    super.key,
    required this.onDevModeChanged,
    required this.isDevMode,
  });

  @override
  State<DeveloppeursButton> createState() => _DeveloppeursButtonState();
}

class _DeveloppeursButtonState extends State<DeveloppeursButton> {
  final TextEditingController _controller = TextEditingController();

  void _showCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Entrer le code développeur'),
          content: TextField(
            controller: _controller,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Code secret"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text == "1234") {
                  widget.onDevModeChanged(true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mode développeur activé ✅"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Code incorrect ❌"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Valider"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  void _handleTap() {
    if (widget.isDevMode) {
      // Si déjà actif → désactive sans demander de code
      widget.onDevModeChanged(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mode développeur désactivé 🔒"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Sinon → demander le code
      _showCodeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          Icon(
            Icons.code,
            color: widget.isDevMode ? Colors.greenAccent : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            "Développeurs",
            style: TextStyle(
              fontSize: 12,
              color: widget.isDevMode ? Colors.greenAccent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}