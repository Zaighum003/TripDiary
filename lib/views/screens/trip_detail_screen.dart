

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/trip_viewmodel.dart';
import '../../viewmodels/entry_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/trip_model.dart';
import '../widgets/entry_thumbnail.dart';
import 'entry_form_screen.dart';
import 'entry_detail_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late Trip? _trip;

  @override
  void initState() {
    super.initState();
    _loadTripData();
  }

  Future<void> _loadTripData() async {
    final tripViewModel = context.read<TripViewModel>();
    _trip = await tripViewModel.getTripById(widget.tripId);
    context.read<EntryViewModel>().loadEntriesByTrip(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Trip?>(
      future: context.read<TripViewModel>().getTripById(widget.tripId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Trip not found')),
          );
        }

        final trip = snapshot.data!;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryFormScreen(
                    tripId: trip.id!,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(trip.title),
                  background: trip.coverImagePath != null
                      ? Image.file(
                          File(trip.coverImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300]);
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                        ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.destination,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${trip.startDate.month}/${trip.startDate.day}/${trip.startDate.year} - ${trip.endDate.month}/${trip.endDate.day}/${trip.endDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              Consumer<EntryViewModel>(
                builder: (context, entryViewModel, _) {
                  final entries = entryViewModel.entriesByTrip;

                  if (entries.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(AppStrings.noEntries),
                        ),
                      ),
                    );
                  }

                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        return Dismissible(
                          key: Key('entry_${entry.id}'),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (_) {
                            entryViewModel.deleteEntry(entry.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(AppStrings.deleted),
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: EntryThumbnail(
                            entry: entry,
                            onTap: () {
                              entryViewModel.selectEntry(entry);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EntryDetailScreen(entryId: entry.id!),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: entries.length,
                    ),
                  );
                },
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 32),
              ),
            ],
          ),
        );
      },
    );
  }
}
