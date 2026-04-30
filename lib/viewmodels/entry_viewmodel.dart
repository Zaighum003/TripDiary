

import 'package:flutter/foundation.dart';
import '../data/models/entry_model.dart';
import '../data/repositories/entry_repository.dart';
import '../core/utils/file_utils.dart';

class EntryViewModel extends ChangeNotifier {
  final EntryRepository _entryRepository;

  List<Entry> _entries = [];
  List<Entry> _entriesByTrip = [];
  Entry? _selectedEntry;
  bool _isLoading = false;
  String? _errorMessage;

  
  List<Entry> get entries => _entries;
  List<Entry> get entriesByTrip => _entriesByTrip;
  Entry? get selectedEntry => _selectedEntry;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EntryViewModel(this._entryRepository);

  Future<void> loadEntries() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _entries = await _entryRepository.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading entries: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadEntriesByTrip(int tripId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _entriesByTrip = await _entryRepository.getByTripId(tripId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading entries: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEntry(Entry entry) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final id = await _entryRepository.insert(entry);
      final newEntry = entry.copyWith(id: id);
      _entries.insert(0, newEntry);
      _entriesByTrip.insert(0, newEntry);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error adding entry: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEntry(Entry entry) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _entryRepository.update(entry);

      final indexAll = _entries.indexWhere((e) => e.id == entry.id);
      if (indexAll >= 0) {
        _entries[indexAll] = entry;
      }

      final indexTrip = _entriesByTrip.indexWhere((e) => e.id == entry.id);
      if (indexTrip >= 0) {
        _entriesByTrip[indexTrip] = entry;
      }

      if (_selectedEntry?.id == entry.id) {
        _selectedEntry = entry;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating entry: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEntry(int entryId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final entry = _entries.firstWhere(
        (e) => e.id == entryId,
        orElse: () => _entriesByTrip.firstWhere(
          (e) => e.id == entryId,
          orElse: () => Entry(
            id: entryId,
            tripId: 0,
            title: '',
            body: '',
            createdAt: DateTime.now(),
          ),
        ),
      );

      if (entry.photoPath != null) {
        await FileUtils.deleteFile(entry.photoPath!);
      }
      if (entry.voiceNotePath != null) {
        await FileUtils.deleteFile(entry.voiceNotePath!);
      }

      await _entryRepository.delete(entryId);

      _entries.removeWhere((e) => e.id == entryId);
      _entriesByTrip.removeWhere((e) => e.id == entryId);

      if (_selectedEntry?.id == entryId) {
        _selectedEntry = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting entry: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Entry?> getEntryById(int id) async {
    try {
      return await _entryRepository.getById(id);
    } catch (e) {
      _errorMessage = 'Error getting entry: $e';
      notifyListeners();
      return null;
    }
  }

  void selectEntry(Entry entry) {
    _selectedEntry = entry;
    notifyListeners();
  }

  void clearSelectedEntry() {
    _selectedEntry = null;
    notifyListeners();
  }

  Future<int> getEntryCountByTrip(int tripId) async {
    try {
      return await _entryRepository.getCountByTripId(tripId);
    } catch (e) {
      print('Error getting entry count: $e');
      return 0;
    }
  }

  Future<List<Entry>> searchEntries(String query) async {
    try {
      if (query.isEmpty) {
        return _entries;
      }
      return await _entryRepository.search(query);
    } catch (e) {
      print('Error searching entries: $e');
      return [];
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
