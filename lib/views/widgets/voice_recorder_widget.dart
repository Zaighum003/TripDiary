// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import '../../services/voice_record_service.dart';
import '../../core/constants/app_strings.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String?) onRecordingComplete;

  const VoiceRecorderWidget({
    Key? key,
    required this.onRecordingComplete,
  }) : super(key: key);

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  late VoiceRecordService _recordService;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _recordService = VoiceRecordService();
  }

  @override
  void dispose() {
    _recordService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final success = await _recordService.startRecording();
    if (success) {
      setState(() {
        _recordingSeconds = 0;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _recordService.isRecording) {
        setState(() {
          _recordingSeconds++;
        });
        _startTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    final filePath = await _recordService.stopRecording();
    widget.onRecordingComplete(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_recordService.isRecording)
          Text(
            '${AppStrings.recording} $_recordingSeconds s',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          const Text(AppStrings.addVoiceNote),
        const SizedBox(height: 12),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _recordService.isRecording ? null : _startRecording,
                icon: const Icon(Icons.mic),
                label: const Text('Record'),
              ),
            ),
            if (_recordService.isRecording) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _stopRecording,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
