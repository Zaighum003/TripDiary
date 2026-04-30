

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/entry_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/entry_model.dart';
import '../../services/location_service.dart';
import '../widgets/photo_picker_widget.dart';
import '../widgets/voice_recorder_widget.dart';

class EntryFormScreen extends StatefulWidget {
  final int tripId;
  final Entry? entry;

  const EntryFormScreen({
    Key? key,
    required this.tripId,
    this.entry,
  }) : super(key: key);

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  String? _photoPath;
  String? _voiceNotePath;
  double? _latitude;
  double? _longitude;
  String? _locationName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _bodyController = TextEditingController(text: widget.entry?.body ?? '');
    _photoPath = widget.entry?.photoPath;
    _voiceNotePath = widget.entry?.voiceNotePath;
    _latitude = widget.entry?.latitude;
    _longitude = widget.entry?.longitude;
    _locationName = widget.entry?.locationName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _addLocation() async {
    setState(() => _isLoading = true);

    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationName =
          await LocationService.getPlaceName(position.latitude, position.longitude);
    }

    setState(() => _isLoading = false);

    if (_locationName != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location: $_locationName')),
      );
    }
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and body')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final entry = Entry(
      id: widget.entry?.id,
      tripId: widget.tripId,
      title: _titleController.text,
      body: _bodyController.text,
      photoPath: _photoPath,
      voiceNotePath: _voiceNotePath,
      latitude: _latitude,
      longitude: _longitude,
      locationName: _locationName,
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
    );

    final entryViewModel = context.read<EntryViewModel>();
    final success = widget.entry == null
        ? await entryViewModel.addEntry(entry)
        : await entryViewModel.updateEntry(entry);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.entry == null
              ? 'Entry created successfully'
              : 'Entry updated successfully'),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving entry')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null
            ? AppStrings.addEntry
            : AppStrings.editEntry),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppStrings.entryTitle,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: AppStrings.entryBody,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            Text(
              AppStrings.addPhoto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            PhotoPickerWidget(
              onPhotoSelected: (path) {
                setState(() => _photoPath = path);
              },
            ),
            const SizedBox(height: 24),

            // Voice note section
            Text(
              AppStrings.addVoiceNote,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            VoiceRecorderWidget(
              onRecordingComplete: (path) {
                setState(() => _voiceNotePath = path);
              },
            ),
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.addLocation,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _addLocation,
                    icon: const Icon(Icons.location_on),
                    label: const Text('Get Location'),
                  ),
                ),
              ],
            ),
            if (_locationName != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Location: $_locationName',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('entry_save_button'),
                onPressed: _isLoading ? null : _saveEntry,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(AppStrings.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
