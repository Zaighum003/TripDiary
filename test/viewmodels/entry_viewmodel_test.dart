import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/viewmodels/entry_viewmodel.dart';
import 'package:trip_diary/data/models/entry_model.dart';
import 'package:trip_diary/data/repositories/entry_repository.dart';

class FakeEntryRepository implements EntryRepository {
  final List<Entry> _entries = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<int> insert(Entry entry) async {
    final newEntry = entry.copyWith(id: _entries.length + 1);
    _entries.add(newEntry);
    return newEntry.id!;
  }

  @override
  Future<List<Entry>> getAll() async {
    return List.from(_entries);
  }

  @override
  Future<List<Entry>> getByTripId(int tripId) async {
    return _entries.where((e) => e.tripId == tripId).toList();
  }

  @override
  Future<Entry?> getById(int id) async {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> update(Entry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
      return 1;
    }
    return 0;
  }

  @override
  Future<int> delete(int id) async {
    final lengthBefore = _entries.length;
    _entries.removeWhere((e) => e.id == id);
    return lengthBefore - _entries.length;
  }

  @override
  Future<int> getCountByTripId(int tripId) async {
    return _entries.where((e) => e.tripId == tripId).length;
  }

  @override
  Future<List<Entry>> search(String query) async {
    return _entries.where((e) => e.title.contains(query) || e.body.contains(query)).toList();
  }
}

void main() {
  group('EntryViewModel Unit Tests', () {
    late EntryViewModel viewModel;
    late FakeEntryRepository repository;

    setUp(() {
      repository = FakeEntryRepository();
      viewModel = EntryViewModel(repository);
    });

    test('Initial state: entries should be empty', () {
      expect(viewModel.entries, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });

    test('addEntry should add an entry to the list', () async {
      final entry = Entry(
        tripId: 1,
        title: 'Test Entry',
        body: 'Test Content',
        createdAt: DateTime.now(),
      );

      final success = await viewModel.addEntry(entry);

      expect(success, isTrue);
      expect(viewModel.entries.length, 1);
      expect(viewModel.entries.first.title, 'Test Entry');
    });

    test('loadEntriesByTrip should update entriesByTrip list', () async {
      await viewModel.addEntry(Entry(
        tripId: 1,
        title: 'Entry 1',
        body: 'Content',
        createdAt: DateTime.now(),
      ));
      await viewModel.addEntry(Entry(
        tripId: 2,
        title: 'Entry 2',
        body: 'Content',
        createdAt: DateTime.now(),
      ));

      await viewModel.loadEntriesByTrip(1);

      expect(viewModel.entriesByTrip.length, 1);
      expect(viewModel.entriesByTrip.first.title, 'Entry 1');
    });

    test('updateEntry should update an existing entry', () async {
      await viewModel.addEntry(Entry(
        tripId: 1,
        title: 'Old Title',
        body: 'Content',
        createdAt: DateTime.now(),
      ));
      final addedEntry = viewModel.entries.first;

      final updatedEntry = addedEntry.copyWith(title: 'New Title');
      final success = await viewModel.updateEntry(updatedEntry);

      expect(success, isTrue);
      expect(viewModel.entries.first.title, 'New Title');
    });

    test('deleteEntry should remove entry from the list', () async {
      await viewModel.addEntry(Entry(
        tripId: 1,
        title: 'To Delete',
        body: 'Content',
        createdAt: DateTime.now(),
      ));
      final addedEntry = viewModel.entries.first;

      final success = await viewModel.deleteEntry(addedEntry.id!);

      expect(success, isTrue);
      expect(viewModel.entries, isEmpty);
    });

    test('selectEntry should update selectedEntry', () {
      final entry = Entry(
        id: 1,
        tripId: 1,
        title: 'Select Me',
        body: 'Content',
        createdAt: DateTime.now(),
      );
      
      viewModel.selectEntry(entry);
      
      expect(viewModel.selectedEntry, equals(entry));
      
      viewModel.clearSelectedEntry();
      expect(viewModel.selectedEntry, isNull);
    });
  });
}
