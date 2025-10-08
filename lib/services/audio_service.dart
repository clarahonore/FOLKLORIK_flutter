import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  /// Joue un fichier audio depuis les assets (ex: "audios/musique.mp3")
  Future<void> playAsset(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath));
  }

  /// Pause la lecture
  Future<void> pause() async {
    await _player.pause();
  }

  /// Reprend la lecture
  Future<void> resume() async {
    await _player.resume();
  }

  /// Arrête complètement la lecture
  Future<void> stop() async {
    await _player.stop();
  }
}