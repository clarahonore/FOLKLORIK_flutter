import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  bool isListening = false;
  String merlinResponse = "";

  Future<void> _sendToMerlin(String message) async {
    setState(() => isListening = true);

    _showMerlinPopup(context);

    final response = await http.post(
      Uri.parse('http://192.168.1.73:3001/api/merlin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final replyText = data["text"];
      final audioBase64 = data["audio"];

      // Met à jour le texte dans la pop-up
      merlinResponse = replyText;
      _updatePopupText(replyText);

      // Joue l’audio
      if (audioBase64 != null) {
        final bytes = base64Decode(audioBase64);
        final player = AudioPlayer();
        await player.play(BytesSource(Uint8List.fromList(bytes)));
      }
    } else {
      _updatePopupText("⚠️ Erreur de connexion avec Merlin 🧙‍♂️");
    }

    setState(() => isListening = false);
  }

  // 🔮 Affiche une pop-up plein écran sombre
  void _showMerlinPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            // Permet de mettre à jour le texte pendant l’audio
            _updatePopupText = (String newText) {
              setStatePopup(() => merlinResponse = newText);
            };

            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.brown, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_fix_high,
                        color: Colors.amberAccent, size: 48),
                    const SizedBox(height: 20),
                    Text(
                      "Merlin parle...",
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      merlinResponse,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Fermer la fenêtre"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Fonction de mise à jour du texte dans la pop-up
  late void Function(String) _updatePopupText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.mic),
      label: Text(isListening ? "Merlin écoute..." : "Parler à Merlin"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: () async {
        await _sendToMerlin("Merlin, aide-moi !");
      },
    );
  }
}