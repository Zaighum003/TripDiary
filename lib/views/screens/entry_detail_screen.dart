

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/entry_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/entry_model.dart';
import '../../services/share_service.dart';
import '../widgets/voice_player_widget.dart';
import '../widgets/location_badge.dart';
import 'entry_form_screen.dart';

class EntryDetailScreen extends StatefulWidget {
  final int entryId;

  const EntryDetailScreen({
    Key? key,
    required this.entryId,
  }) : super(key: key);

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteEntry),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<EntryViewModel>().deleteEntry(widget.entryId);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.deleted)),
              );
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Entry?>(
      future: context.read<EntryViewModel>().getEntryById(widget.entryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Entry not found')),
          );
        }

        final entry = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.details),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryFormScreen(
                        tripId: entry.tripId,
                        entry: entry,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ShareService.shareEntry(entry);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _showDeleteConfirm,
              ),
            ],
          ),
          body: Column(
            children: [
              // TabBar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: AppStrings.details),
                  Tab(text: AppStrings.media),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          if (entry.locationName != null)
                            LocationBadge(
                              locationName: entry.locationName!,
                            ),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.photoPath != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Photo',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(entry.photoPath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        height: 200,
                                        child: const Center(
                                          child:
                                              Text('Photo unavailable'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            )
                          else
                            const Text('No photo'),
                          const SizedBox(height: 16),

                          if (entry.voiceNotePath != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Voice Note',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                VoicePlayerWidget(
                                  voiceNotePath: entry.voiceNotePath!,
                                ),
                              ],
                            )
                          else
                            const Text('No voice note'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
