import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mon_app/services/accessibilite_status.dart';

class AccessibilitePage extends StatefulWidget {
  const AccessibilitePage({super.key});

  @override
  State<AccessibilitePage> createState() => _AccessibilitePageState();
}

class _AccessibilitePageState extends State<AccessibilitePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playAudio(String audioPath) async {
    final access = context.read<AccessibiliteStatus>();
    if (access.narrationActive) {
      try {
        await _audioPlayer.setSource(AssetSource(audioPath));
        await _audioPlayer.setVolume(0.85);
        await _audioPlayer.resume();
      } catch (e) {
        debugPrint("Erreur audio $audioPath : $e");
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres d'accessibilité"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Options d'accessibilité",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🎧 Son
            SwitchListTile(
              title: const Text("Activer le son"),
              subtitle: const Text("Active ou désactive la lecture audio"),
              value: access.sonActive,
              onChanged: (_) {
                access.toggleSon();
                _playAudio(access.sonActive ? 'audio/son_on.mp3' : 'audio/son_off.mp3');
              },
              activeColor: Colors.brown,
            ),

            // 👁️ Contraste élevé
            SwitchListTile(
              title: const Text("Contraste élevé"),
              subtitle: const Text("Améliore la lisibilité des textes"),
              value: access.contraste,
              onChanged: (_) {
                access.toggleContraste();
                _playAudio(access.contraste ? 'audio/contraste_on.mp3' : 'audio/contraste_off.mp3');
              },
              activeColor: Colors.brown,
            ),

            // 🎨 Daltonisme
            SwitchListTile(
              title: const Text("Mode daltonien"),
              subtitle: const Text("Adapte les couleurs pour une meilleure visibilité"),
              value: access.daltonisme,
              onChanged: (_) {
                access.toggleDaltonisme();
                _playAudio(access.daltonisme ? 'audio/daltonisme_on.mp3' : 'audio/daltonisme_off.mp3');
              },
              activeColor: Colors.brown,
            ),

            // 🔠 Taille du texte
            SwitchListTile(
              title: const Text("Texte agrandi"),
              subtitle: const Text("Augmente la taille des polices"),
              value: access.texteGrand,
              onChanged: (_) {
                access.toggleTexteGrand();
                _playAudio(access.texteGrand ? 'audio/texte_on.mp3' : 'audio/texte_off.mp3');
              },
              activeColor: Colors.brown,
            ),

            // 📝 Narration
            SwitchListTile(
              title: const Text("Narration"),
              subtitle: const Text("Active ou désactive la narration globale"),
              value: access.narrationActive,
              onChanged: (_) => access.toggleNarration(),
              activeColor: Colors.brown,
            ),

            const Spacer(),

            // 🔙 Bouton retour avec audio
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5E3C),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  _playAudio('audio/retour_access.mp3');
                  Navigator.pop(context);
                },
                child: const Text(
                  "RETOUR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
