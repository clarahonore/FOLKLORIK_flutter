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
  final AudioPlayer _buttonAudio = AudioPlayer(); // pour le bouton retour
  bool _retourAudioPlayed = false; // gére le double clic

  Future<void> _playAudio(String audioPath) async {
    final access = context.read<AccessibiliteStatus>();
    if (access.narrationActive) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setSource(AssetSource(audioPath));
        await _audioPlayer.setVolume(0.85);
        await _audioPlayer.resume();
      } catch (e) {
        debugPrint("Erreur audio $audioPath : $e");
      }
    }
  }

  Future<void> _handleRetourButton(BuildContext context) async {
    final access = context.read<AccessibiliteStatus>();

    if (access.narrationActive && !_retourAudioPlayed) {
      // Premier clic = le son
      try {
        await _buttonAudio.stop();
        await _buttonAudio.setSource(AssetSource('audio/Retour.m4a'));
        await _buttonAudio.setVolume(0.85);
        await _buttonAudio.resume();
        setState(() => _retourAudioPlayed = true);
      } catch (e) {
        debugPrint("Erreur audio Retour.m4a : $e");
      }
    } else {
      // Deuxième clic (ou narration désactivée) = retour à la page précédente
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _buttonAudio.dispose();
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
                _playAudio(access.sonActive
                    ? 'audio/son activé.m4a'
                    : 'audio/son désactivé.m4a');
              },
              activeColor: Colors.brown,
            ),

            // Contraste élevé
            SwitchListTile(
              title: const Text("Contraste élevé"),
              subtitle: const Text("Améliore la lisibilité des textes"),
              value: access.contraste,
              onChanged: (_) {
                access.toggleContraste();
                _playAudio(access.contraste
                    ? 'audio/Contraste activé.m4a'
                    : 'audio/Contraste désactivé.m4a');
              },
              activeColor: Colors.brown,
            ),

            // Daltonisme
            SwitchListTile(
              title: const Text("Mode daltonien"),
              subtitle:
              const Text("Adapte les couleurs pour une meilleure visibilité"),
              value: access.daltonisme,
              onChanged: (_) {
                access.toggleDaltonisme();
                _playAudio(access.daltonisme
                    ? 'audio/Mode daltonien activé.m4a'
                    : 'audio/Mode daltonien désactivé.m4a');
              },
              activeColor: Colors.brown,
            ),

            // Taille du texte
            SwitchListTile(
              title: const Text("Texte agrandi"),
              subtitle: const Text("Augmente la taille des polices"),
              value: access.texteGrand,
              onChanged: (_) {
                access.toggleTexteGrand();
                _playAudio(access.texteGrand
                    ? 'audio/Texte agrandi activé.m4a'
                    : 'audio/texte agrandi désactivé.m4a');
              },
              activeColor: Colors.brown,
            ),

            // Narration
            SwitchListTile(
              title: const Text("Narration"),
              subtitle:
              const Text("Active ou désactive la narration globale"),
              value: access.narrationActive,
              onChanged: (_) => access.toggleNarration(),
              activeColor: Colors.brown,
            ),

            const Spacer(),

            // Bouton retour avec double clic audio
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5E3C),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _handleRetourButton(context),
                child: const Text(
                  "RETOUR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
