// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/trip_model.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int entryCount;

  const TripCard({
    Key? key,
    required this.trip,
    required this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.entryCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Stack(
          children: [
            // Background image or placeholder
            if (trip.coverImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Image.file(
                  File(trip.coverImagePath!),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.lightGrey,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

            // Overlay gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.overlay],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.destination,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGrey,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${trip.startDate.month}/${trip.startDate.day} - ${trip.endDate.month}/${trip.endDate.day}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.lightGrey,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius:
                                BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          child: Text(
                            '$entryCount ${AppStrings.entries}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action menu button
            if (onEdit != null || onDelete != null)
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        child: const Text(AppStrings.edit),
                        onTap: onEdit,
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        child: const Text(AppStrings.deleteTrip),
                        onTap: onDelete,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
