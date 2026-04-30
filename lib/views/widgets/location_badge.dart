// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class LocationBadge extends StatelessWidget {
  final String locationName;
  final bool isCompact;

  const LocationBadge({
    Key? key,
    required this.locationName,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: isCompact ? 14 : 16,
            color: AppColors.black,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              locationName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
