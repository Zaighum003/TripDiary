// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/image_service.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class PhotoPickerWidget extends StatefulWidget {
  final Function(String?) onPhotoSelected;

  const PhotoPickerWidget({
    Key? key,
    required this.onPhotoSelected,
  }) : super(key: key);

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  File? _selectedPhoto;

  Future<void> _pickFromCamera() async {
    final photo = await ImageService.capturePhoto();
    if (photo != null) {
      final savedPath = await ImageService.savePhoto(photo);
      setState(() {
        _selectedPhoto = File(savedPath ?? photo.path);
      });
      widget.onPhotoSelected(savedPath ?? photo.path);
    }
  }

  Future<void> _pickFromGallery() async {
    final photo = await ImageService.pickFromGallery();
    if (photo != null) {
      final savedPath = await ImageService.savePhoto(photo);
      setState(() {
        _selectedPhoto = File(savedPath ?? photo.path);
      });
      widget.onPhotoSelected(savedPath ?? photo.path);
    }
  }

  void _clearPhoto() {
    setState(() {
      _selectedPhoto = null;
    });
    widget.onPhotoSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedPhoto != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedPhoto!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton.small(
                  onPressed: _clearPhoto,
                  backgroundColor: AppColors.error,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          )
        else
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightGrey,
            ),
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 48,
                color: AppColors.grey,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text(AppStrings.camera),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.image),
                label: const Text(AppStrings.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
