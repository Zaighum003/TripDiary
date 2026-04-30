

import 'dart:io';

import 'package:record/record.dart';
import '../core/utils/file_utils.dart';
import '../core/constants/app_constants.dart';

class VoiceRecordService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> isRecordingSupported() async {
    try {
      return await _recorder.hasPermission();
    } catch (e) {
      print('Error checking recording support: $e');
      return false;
    }
  }

  Future<bool> startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        print('Microphone permission denied');
        return false;
      }

      final voiceDir = await FileUtils.getVoiceNotesDirectory();
      final fileName =
          FileUtils.generateUniqueFileName(AppConstants.audioFileExtension);
      final filePath = '$voiceDir/$fileName';

      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      _isRecording = true;
      print('Recording started: $filePath');
      return true;
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) {
        print('Recording not in progress');
        return null;
      }

      final filePath = await _recorder.stop();
      _isRecording = false;

      print('Recording stopped: $filePath');
      return filePath;
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _recorder.stop();
      _isRecording = false;
      print('Recording cancelled');
    } catch (e) {
      print('Error cancelling recording: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _recorder.dispose();
    } catch (e) {
      print('Error disposing recorder: $e');
    }
  }
}
