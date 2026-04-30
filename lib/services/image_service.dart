

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/utils/file_utils.dart';

class ImageService {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> capturePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return File(photo.path);
    } catch (e) {
      print('Error capturing photo: $e');
      return null;
    }
  }

  static Future<File?> pickFromGallery() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return File(photo.path);
    } catch (e) {
      print('Error picking from gallery: $e');
      return null;
    }
  }

  static Future<String?> savePhoto(File photoFile) async {
    try {
      final destinationDir = await FileUtils.getEntryPhotosDirectory();
      final savedFile = await FileUtils.saveFile(photoFile, destinationDir);
      return savedFile;
    } catch (e) {
      print('Error saving photo: $e');
      return null;
    }
  }

  static Future<String?> saveCoverImage(File imageFile) async {
    try {
      final destinationDir = await FileUtils.getTripCoversDirectory();
      final savedFile = await FileUtils.saveFile(imageFile, destinationDir);
      return savedFile;
    } catch (e) {
      print('Error saving cover image: $e');
      return null;
    }
  }
}
