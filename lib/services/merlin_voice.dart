import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MerlinVoice {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;

  Future<void> initVoice() async {
    await _speech.initialize();
    await _tts.setLanguage("fr-FR");
    await _tts.setVoice({"name": "fr-fr-x-frc-local", "locale": "fr-FR"});
    await _tts.setPitch(0.8); // voix plus grave
    await _tts.setSpeechRate(0.9); // rythme lent, façon vieillard
    await _tts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  Future<String?> listen() async {
    if (_isListening) return null;

    _isListening = true;
    String recognized = "";

    await _speech.listen(onResult: (val) {
      recognized = val.recognizedWords;
    });

    // attend 5 secondes d'écoute puis stop
    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();

    _isListening = false;
    return recognized.isEmpty ? null : recognized;
  }
}