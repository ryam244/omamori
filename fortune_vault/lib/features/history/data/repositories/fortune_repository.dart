// lib/features/history/data/repositories/fortune_repository.dart

import '../../../../models/omikuji_entry.dart';
import '../database/fortune_database.dart';

/// Fortune Repository
/// Provides a clean interface for fortune data operations
class FortuneRepository {
  final FortuneDatabase _database = FortuneDatabase.instance;

  /// Save a new fortune entry
  Future<OmikujiEntry> save(OmikujiEntry entry) async {
    return await _database.create(entry);
  }

  /// Get fortune entry by ID
  Future<OmikujiEntry?> getById(String id) async {
    return await _database.readById(id);
  }

  /// Get all fortune entries
  Future<List<OmikujiEntry>> getAll() async {
    return await _database.readAll();
  }

  /// Get entries by shrine name
  Future<List<OmikujiEntry>> getByShrine(String shrineName) async {
    return await _database.readByShrine(shrineName);
  }

  /// Get favorite entries
  Future<List<OmikujiEntry>> getFavorites() async {
    return await _database.readFavorites();
  }

  /// Update fortune entry
  Future<bool> update(OmikujiEntry entry) async {
    final count = await _database.update(entry);
    return count > 0;
  }

  /// Delete fortune entry
  Future<bool> delete(String id) async {
    final count = await _database.delete(id);
    return count > 0;
  }

  /// Search entries
  Future<List<OmikujiEntry>> search(String keyword) async {
    return await _database.search(keyword);
  }

  /// Get statistics
  Future<Map<String, int>> getStats() async {
    return await _database.getStats();
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String id) async {
    final entry = await _database.readById(id);
    if (entry == null) return false;

    final updated = entry.copyWith(isFavorite: !entry.isFavorite);
    return await update(updated);
  }
}
