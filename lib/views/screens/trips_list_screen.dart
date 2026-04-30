// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/trip_viewmodel.dart';
import '../../viewmodels/entry_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/search_bar_with_voice.dart';
import '../widgets/trip_card.dart';
import 'trip_form_screen.dart';
import 'trip_detail_screen.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({Key? key}) : super(key: key);

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  void _showDeleteConfirmDialog(BuildContext context, int tripId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteTrip),
          content: const Text(AppStrings.deleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<TripViewModel>().deleteTrip(tripId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip deleted')),
                );
              },
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.trips),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<SearchViewModel>(
              builder: (context, searchViewModel, _) {
                return SearchBarWithVoice(
                  onSearchChanged: searchViewModel.updateSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: Consumer2<TripViewModel, SearchViewModel>(
              builder: (context, tripViewModel, searchViewModel, _) {
                final trips = searchViewModel.searchQuery.isEmpty
                    ? tripViewModel.trips
                    : searchViewModel.searchResults;

                if (tripViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (trips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.travel_explore,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchViewModel.isEmptySearch
                              ? AppStrings.noSearchResults
                              : AppStrings.noTrips,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return FutureBuilder<int>(
                      future: context.read<EntryViewModel>().getEntryCountByTrip(trip.id!),
                      builder: (context, snapshot) {
                        return TripCard(
                          trip: trip,
                          entryCount: snapshot.data ?? 0,
                          onTap: () {
                            tripViewModel.selectTrip(trip);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailScreen(
                                  tripId: trip.id!,
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripFormScreen(
                                  trip: trip,
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmDialog(context, trip.id!);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TripFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
