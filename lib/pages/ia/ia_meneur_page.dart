import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() {
  runApp(const IAHelperApp());
}

class IAHelperApp extends StatelessWidget {
  const IAHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IAMeneurPage(),
    );
  }
}

class IAMeneurPage extends StatefulWidget {
  final String systemPrompt;

  const IAMeneurPage({
    super.key,
    this.systemPrompt = "Tu es le maître du jeu d'un escape game médiéval. Aide le joueur avec des indices utiles mais immersifs.",
  });

  @override
  State<IAMeneurPage> createState() => _IAMeneurPageState();
}

class _IAMeneurPageState extends State<IAMeneurPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  final FlutterTts _flutterTts = FlutterTts();
  String _response = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) async {
          setState(() {
            _spokenText = val.recognizedWords;
          });

          if (!_speech.isListening) {
            _isListening = false;
            await _askGPT(_spokenText);

          }
        },
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  Future<void> _askGPT(String message) async {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
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
          {"role": "system", "content": "Tu es le maître du jeu [...]"},
          {"role": "system", "content": widget.systemPrompt},
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
      setState(() => _response = "Erreur lors de la requête à l'IA.");
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parlez au maître du jeu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isListening ? null : _listen,
              icon: const Icon(Icons.mic),
              label: const Text("Parler"),
            ),
            const SizedBox(height: 20),
            if (_spokenText.isNotEmpty)
              Text(
                'Vous : $_spokenText',
                style: const TextStyle(color: Colors.white70),
              ),
            const SizedBox(height: 16),
            if (_response.isNotEmpty)
              Text(
                'IA : $_response',
                style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}