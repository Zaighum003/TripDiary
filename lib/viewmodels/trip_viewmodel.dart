
import 'package:flutter/foundation.dart';
import '../data/models/trip_model.dart';
import '../data/repositories/trip_repository.dart';
import '../core/utils/file_utils.dart';

class TripViewModel extends ChangeNotifier {
  final TripRepository _tripRepository;

  List<Trip> _trips = [];
  Trip? _selectedTrip;
  bool _isLoading = false;
  String? _errorMessage;

  List<Trip> get trips => _trips;
  Trip? get selectedTrip => _selectedTrip;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TripViewModel(this._tripRepository) {
    loadTrips();
  }

  Future<void> loadTrips() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _trips = await _tripRepository.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading trips: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTrip(Trip trip) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final id = await _tripRepository.insert(trip);
      final newTrip = trip.copyWith(id: id);
      _trips.insert(0, newTrip); 

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error adding trip: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTrip(Trip trip) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _tripRepository.update(trip);

      final index = _trips.indexWhere((t) => t.id == trip.id);
      if (index >= 0) {
        _trips[index] = trip;
      }

      if (_selectedTrip?.id == trip.id) {
        _selectedTrip = trip;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating trip: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTrip(int tripId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _tripRepository.delete(tripId);

      final trip = _trips.firstWhere((t) => t.id == tripId);
      if (trip.coverImagePath != null) {
        await FileUtils.deleteFile(trip.coverImagePath!);
      }

      _trips.removeWhere((t) => t.id == tripId);

      if (_selectedTrip?.id == tripId) {
        _selectedTrip = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting trip: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Trip?> getTripById(int id) async {
    try {
      return await _tripRepository.getById(id);
    } catch (e) {
      _errorMessage = 'Error getting trip: $e';
      notifyListeners();
      return null;
    }
  }

  void selectTrip(Trip trip) {
    _selectedTrip = trip;
    notifyListeners();
  }

  void clearSelectedTrip() {
    _selectedTrip = null;
    notifyListeners();
  }

  Future<List<Trip>> searchTrips(String query) async {
    try {
      if (query.isEmpty) {
        return _trips;
      }
      return await _tripRepository.search(query);
    } catch (e) {
      print('Error searching trips: $e');
      return [];
    }
  }

  Future<int> getTripCount() async {
    try {
      return await _tripRepository.getCount();
    } catch (e) {
      return _trips.length;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
