
import 'package:flutter/foundation.dart';
import '../data/models/trip_model.dart';
import '../data/repositories/trip_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final TripRepository _tripRepository;

  String _searchQuery = '';
  List<Trip> _searchResults = [];
  bool _isSearching = false;

  String get searchQuery => _searchQuery;
  List<Trip> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get hasSearchResults => _searchResults.isNotEmpty;
  bool get isEmptySearch => _searchQuery.isNotEmpty && _searchResults.isEmpty;

  SearchViewModel(this._tripRepository);

  Future<void> updateSearchQuery(String query) async {
    _searchQuery = query;
    _isSearching = true;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _searchResults = [];
        _isSearching = false;
        notifyListeners();
        return;
      }

      _searchResults = await _tripRepository.search(query);
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      print('Error searching: $e');
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  List<Trip> getFilteredTrips(List<Trip> allTrips) {
    if (_searchQuery.isEmpty) {
      return allTrips;
    }

    return allTrips
        .where((trip) =>
            trip.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            trip.destination.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
}
