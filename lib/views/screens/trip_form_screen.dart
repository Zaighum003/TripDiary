// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/trip_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/trip_model.dart';
import '../../services/image_service.dart';
import '../widgets/photo_picker_widget.dart';
import 'dart:io';

class TripFormScreen extends StatefulWidget {
  final Trip? trip;

  const TripFormScreen({
    Key? key,
    this.trip,
  }) : super(key: key);

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _destinationController;
  late DateTime _startDate;
  late DateTime _endDate;
  String? _coverImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.trip?.title ?? '');
    _destinationController =
        TextEditingController(text: widget.trip?.destination ?? '');
    _startDate = widget.trip?.startDate ?? DateTime.now();
    _endDate = widget.trip?.endDate ??
        DateTime.now().add(const Duration(days: 7));
    _coverImagePath = widget.trip?.coverImagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _saveTrip() async {
    if (_titleController.text.isEmpty ||
        _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final trip = Trip(
      id: widget.trip?.id,
      title: _titleController.text,
      destination: _destinationController.text,
      startDate: _startDate,
      endDate: _endDate,
      coverImagePath: _coverImagePath,
    );

    final tripViewModel = context.read<TripViewModel>();
    final success = widget.trip == null
        ? await tripViewModel.addTrip(trip)
        : await tripViewModel.updateTrip(trip);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.trip == null
              ? 'Trip created successfully'
              : 'Trip updated successfully'),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving trip')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip == null
            ? AppStrings.addTrip
            : AppStrings.editTrip),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppStrings.tripTitle,
                hintText: 'e.g., Summer Vacation',
              ),
            ),
            const SizedBox(height: 16),

            // Destination field
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: AppStrings.destination,
                hintText: 'e.g., Paris, France',
              ),
            ),
            const SizedBox(height: 16),

            // Start date
            ListTile(
              title: const Text(AppStrings.startDate),
              subtitle: Text(
                '${_startDate.month}/${_startDate.day}/${_startDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectStartDate,
            ),
            const SizedBox(height: 8),

            // End date
            ListTile(
              title: const Text(AppStrings.endDate),
              subtitle: Text(
                '${_endDate.month}/${_endDate.day}/${_endDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectEndDate,
            ),
            const SizedBox(height: 24),

            // Cover photo picker
            Text(
              AppStrings.coverPhoto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            PhotoPickerWidget(
              onPhotoSelected: (path) {
                setState(() => _coverImagePath = path);
              },
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('trip_save_button'),
                onPressed: _isLoading ? null : _saveTrip,
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
