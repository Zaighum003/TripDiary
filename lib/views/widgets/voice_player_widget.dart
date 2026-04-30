// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/voice_playback_service.dart';
import '../../core/constants/app_colors.dart';

class VoicePlayerWidget extends StatefulWidget {
  final String voiceNotePath;

  const VoicePlayerWidget({
    Key? key,
    required this.voiceNotePath,
  }) : super(key: key);

  @override
  State<VoicePlayerWidget> createState() => _VoicePlayerWidgetState();
}

class _VoicePlayerWidgetState extends State<VoicePlayerWidget> {
  late VoicePlaybackService _playbackService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _playbackService = VoicePlaybackService();
    _initializePlayback();
  }

  Future<void> _initializePlayback() async {
    final success = await _playbackService.initializePlayback(widget.voiceNotePath);
    setState(() {
      _isInitialized = success;
    });
  }

  @override
  void dispose() {
    _playbackService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return StreamBuilder<PlayerState>(
      stream: _playbackService.playerStateStream,
      builder: (context, playerState) {
        return StreamBuilder<Duration>(
          stream: _playbackService.positionStream,
          builder: (context, positionStream) {
            final isPlaying = playerState.data?.playing ?? false;
            final position = positionStream.data ?? Duration.zero;
            final duration = _playbackService.getDuration() ?? Duration.zero;

            return Column(
              children: [
                // Play/Pause Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.small(
                      onPressed: isPlaying
                          ? _playbackService.pause
                          : _playbackService.play,
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Seek Bar
                Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _playbackService.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.lightGrey,
                ),

                // Time Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
