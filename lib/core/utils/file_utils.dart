// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/app_constants.dart';

class FileUtils {
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<String> getTripCoversDirectory() async {
    final dir = await getAppDocumentsDirectory();
    final tripDir = Directory('${dir.path}/${AppConstants.tripsImageDir}');
    if (!await tripDir.exists()) {
      await tripDir.create(recursive: true);
    }
    return tripDir.path;
  }

  static Future<String> getEntryPhotosDirectory() async {
    final dir = await getAppDocumentsDirectory();
    final photoDir = Directory('${dir.path}/${AppConstants.entryPhotosDir}');
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }
    return photoDir.path;
  }

  static Future<String> getVoiceNotesDirectory() async {
    final dir = await getAppDocumentsDirectory();
    final voiceDir = Directory('${dir.path}/${AppConstants.voiceNotesDir}');
    if (!await voiceDir.exists()) {
      await voiceDir.create(recursive: true);
    }
    return voiceDir.path;
  }

  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  static Future<String> saveFile(File sourceFile, String destinationDir) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${sourceFile.path.split('/').last}';
    final destinationPath = '$destinationDir/$fileName';
    final savedFile = await sourceFile.copy(destinationPath);
    return savedFile.path;
  }

  static String generateUniqueFileName(String extension) {
    return '${DateTime.now().millisecondsSinceEpoch}$extension';
  }
}
