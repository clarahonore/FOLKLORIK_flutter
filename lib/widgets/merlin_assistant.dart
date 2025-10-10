import 'package:flutter/material.dart';
import '../services/merlin_service.dart';
import '../services/merlin_voice.dart';

class MerlinAssistant extends StatefulWidget {
  const MerlinAssistant({super.key});

  @override
  State<MerlinAssistant> createState() => _MerlinAssistantState();
}

class _MerlinAssistantState extends State<MerlinAssistant> {
  final MerlinService _merlin = MerlinService();
  final MerlinVoice _voice = MerlinVoice();

  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _voice.initVoice();
  }

  Future<void> _activateMerlin() async {
    setState(() => _isListening = true);

    final heard = await _voice.listen();
    setState(() => _isListening = false);

    if (heard == null || heard.isEmpty) {
      await _voice.speak("Je n’ai rien entendu, jeune aventurier...");
      return;
    }

    setState(() => _isSpeaking = true);
    final reply = await MerlinService.askMerlin(heard);
    await _voice.speak(reply);
    setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: _activateMerlin,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFBF8038), Color(0xFF593C1A)],
              center: Alignment(-0.3, -0.4),
              radius: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isSpeaking
                    ? Colors.yellowAccent.withOpacity(0.8)
                    : Colors.black54,
                blurRadius: _isSpeaking ? 25 : 8,
                spreadRadius: _isSpeaking ? 5 : 2,
              ),
            ],
          ),
          child: Icon(
            _isListening ? Icons.hearing : Icons.mic_none,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}