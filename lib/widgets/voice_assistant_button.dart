import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceAssistantButton extends StatefulWidget {
  final String systemPrompt;
  final Color color;

  const VoiceAssistantButton({
    super.key,
    required this.systemPrompt,
    this.color = Colors.red,
  });

  @override
  State<VoiceAssistantButton> createState() => _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends State<VoiceAssistantButton> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _spokenText = '';
  String _response = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    final available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) async {
          setState(() => _spokenText = val.recognizedWords);

          if (!_speech.isListening) {
            setState(() => _isListening = false);
            await _askGPT(_spokenText);
          }
        },
      );
    }
  }

  Future<void> _askGPT(String message) async {
    const apiKey = 'YOUR_OPENAI_API_KEY'; // 🔐 À remplacer dans les variables d'environnement si besoin
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {"role": "system", "content": widget.systemPrompt},
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];

      setState(() => _response = reply);
      await _flutterTts.setLanguage("fr-FR");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(reply);
    } else {
      setState(() => _response = "Erreur de l'IA.");
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isListening ? null : _listen,
          icon: const Icon(Icons.mic),
          label: Text(_isListening ? "Écoute..." : "Parler au maître du jeu"),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        if (_spokenText.isNotEmpty)
          Text('Vous : $_spokenText', style: const TextStyle(color: Colors.white70)),
        if (_response.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('IA : $_response', style: const TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}