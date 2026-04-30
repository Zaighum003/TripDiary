import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/viewmodels/trip_viewmodel.dart';
import 'package:trip_diary/data/models/trip_model.dart';
import 'package:trip_diary/data/repositories/trip_repository.dart';

class FakeTripRepository implements TripRepository {
  final List<Trip> _trips = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<int> insert(Trip trip) async {
    final newTrip = trip.copyWith(id: _trips.length + 1);
    _trips.add(newTrip);
    return newTrip.id!;
  }

  @override
  Future<List<Trip>> getAll() async {
    return List.from(_trips);
  }

  @override
  Future<Trip?> getById(int id) async {
    try {
      return _trips.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> update(Trip trip) async {
    final index = _trips.indexWhere((t) => t.id == trip.id);
    if (index >= 0) {
      _trips[index] = trip;
      return 1;
    }
    return 0;
  }

  @override
  Future<int> delete(int id) async {
    final lengthBefore = _trips.length;
    _trips.removeWhere((t) => t.id == id);
    return lengthBefore - _trips.length;
  }

  @override
  Future<int> getCount() async {
    return _trips.length;
  }

  @override
  Future<List<Trip>> search(String query) async {
    return _trips.where((t) => t.title.contains(query) || t.destination.contains(query)).toList();
  }
}

void main() {
  group('TripViewModel Unit Tests', () {
    late TripViewModel viewModel;
    late FakeTripRepository repository;

    setUp(() {
      repository = FakeTripRepository();
      viewModel = TripViewModel(repository);
    });

    test('Initial state: trips should be empty', () async {
      // Note: TripViewModel calls loadTrips() in constructor
      await Future.delayed(Duration.zero); // Wait for async init
      expect(viewModel.trips, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });

    test('addTrip should add a trip to the list', () async {
      final trip = Trip(
        title: 'Test Trip',
        destination: 'Test City',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
      );

      final success = await viewModel.addTrip(trip);

      expect(success, isTrue);
      expect(viewModel.trips.length, 1);
      expect(viewModel.trips.first.title, 'Test Trip');
    });

    test('updateTrip should update an existing trip', () async {
      final trip = Trip(
        title: 'Test Trip',
        destination: 'Test City',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
      );
      await viewModel.addTrip(trip);
      final addedTrip = viewModel.trips.first;

      final updatedTrip = addedTrip.copyWith(title: 'Updated Trip');
      final success = await viewModel.updateTrip(updatedTrip);

      expect(success, isTrue);
      expect(viewModel.trips.first.title, 'Updated Trip');
    });

    test('deleteTrip should remove trip from the list', () async {
      final trip = Trip(
        title: 'To Delete',
        destination: 'Dest',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
      await viewModel.addTrip(trip);
      final addedTrip = viewModel.trips.first;

      final success = await viewModel.deleteTrip(addedTrip.id!);

      expect(success, isTrue);
      expect(viewModel.trips, isEmpty);
    });

    test('selectTrip should update selectedTrip', () {
      final trip = Trip(
        id: 1,
        title: 'Select Me',
        destination: 'Dest',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
      
      viewModel.selectTrip(trip);
      
      expect(viewModel.selectedTrip, equals(trip));
      
      viewModel.clearSelectedTrip();
      expect(viewModel.selectedTrip, isNull);
    });
  });
}
