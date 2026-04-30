
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class VoicePlaybackService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<bool> initializePlayback(String filePath) async {
    try {
      if (!await File(filePath).exists()) {
        print('Audio file does not exist: $filePath');
        return false;
      }

      await _audioPlayer.setFilePath(filePath);
      return true;
    } catch (e) {
      print('Error initializing playback: $e');
      return false;
    }
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  Duration? getDuration() {
    return _audioPlayer.duration;
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  bool get isPlaying => _audioPlayer.playing;

  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }
}
