// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class SearchBarWithVoice extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function()? onSearchSubmit;

  const SearchBarWithVoice({
    Key? key,
    required this.onSearchChanged,
    this.onSearchSubmit,
  }) : super(key: key);

  @override
  State<SearchBarWithVoice> createState() => _SearchBarWithVoiceState();
}

class _SearchBarWithVoiceState extends State<SearchBarWithVoice> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onSearchChanged,
      onSubmitted: (_) => widget.onSearchSubmit?.call(),
      decoration: InputDecoration(
        hintText: AppStrings.searchTrips,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.mic_none),
          onPressed: widget.onSearchSubmit,
          tooltip: AppStrings.voiceSearchTap,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
