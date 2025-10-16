import 'package:flutter/material.dart';

class DeveloppeursButton extends StatefulWidget {
  final VoidCallback onDevModeActivated;

  const DeveloppeursButton({super.key, required this.onDevModeActivated});

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
                  widget.onDevModeActivated();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCodeDialog,
      child: Column(
        children: const [
          Icon(Icons.code, color: Colors.white),
          SizedBox(height: 4),
          Text("Développeurs", style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
