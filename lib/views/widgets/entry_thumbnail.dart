// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/entry_model.dart';
import 'location_badge.dart';

class EntryThumbnail extends StatelessWidget {
  final Entry entry;
  final VoidCallback onTap;

  const EntryThumbnail({
    Key? key,
    required this.entry,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo or placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  topRight: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: entry.photoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadius),
                        topRight: Radius.circular(AppConstants.borderRadius),
                      ),
                      child: Image.file(
                        File(entry.photoPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: AppColors.grey,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.photo_library,
                      color: AppColors.grey,
                      size: 32,
                    ),
            ),

            // Title and location
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (entry.locationName != null)
                      LocationBadge(
                        locationName: entry.locationName!,
                        isCompact: true,
                      )
                    else if (entry.voiceNotePath != null)
                      Chip(
                        label: const Text('🎵'),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
