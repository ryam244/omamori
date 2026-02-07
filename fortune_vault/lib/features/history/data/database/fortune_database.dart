// lib/features/history/data/database/fortune_database.dart

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../models/omikuji_entry.dart';
import '../../../../models/fortune_analysis.dart';

/// Fortune Database
/// Manages local SQLite database for storing fortune entries
class FortuneDatabase {
  static final FortuneDatabase instance = FortuneDatabase._init();
  static Database? _database;

  FortuneDatabase._init();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fortune_vault.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE omikuji_entries (
  id $idType,
  createdAt $textType,
  shrineName TEXT,
  imageLocalPath $textType,
  ocrTextRaw $textType,
  parsedJson $textType,
  userMemo TEXT,
  tags TEXT,
  version $intType,
  updatedAt TEXT,
  isFavorite $boolType
)
''');

    // Create indexes for better query performance
    await db.execute('''
CREATE INDEX idx_createdAt ON omikuji_entries(createdAt DESC)
''');

    await db.execute('''
CREATE INDEX idx_shrineName ON omikuji_entries(shrineName)
''');

    await db.execute('''
CREATE INDEX idx_isFavorite ON omikuji_entries(isFavorite)
''');
  }

  /// Create a new fortune entry
  Future<OmikujiEntry> create(OmikujiEntry entry) async {
    final db = await database;

    await db.insert(
      'omikuji_entries',
      _toMap(entry),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entry;
  }

  /// Read a fortune entry by ID
  Future<OmikujiEntry?> readById(String id) async {
    final db = await database;

    final maps = await db.query(
      'omikuji_entries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  /// Read all fortune entries
  Future<List<OmikujiEntry>> readAll() async {
    final db = await database;

    const orderBy = 'createdAt DESC';
    final result = await db.query('omikuji_entries', orderBy: orderBy);

    return result.map((map) => _fromMap(map)).toList();
  }

  /// Read entries by shrine name
  Future<List<OmikujiEntry>> readByShrine(String shrineName) async {
    final db = await database;

    final result = await db.query(
      'omikuji_entries',
      where: 'shrineName = ?',
      whereArgs: [shrineName],
      orderBy: 'createdAt DESC',
    );

    return result.map((map) => _fromMap(map)).toList();
  }

  /// Read favorite entries
  Future<List<OmikujiEntry>> readFavorites() async {
    final db = await database;

    final result = await db.query(
      'omikuji_entries',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );

    return result.map((map) => _fromMap(map)).toList();
  }

  /// Update a fortune entry
  Future<int> update(OmikujiEntry entry) async {
    final db = await database;

    return db.update(
      'omikuji_entries',
      _toMap(entry),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  /// Delete a fortune entry
  Future<int> delete(String id) async {
    final db = await database;

    return await db.delete(
      'omikuji_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Search entries by keyword
  Future<List<OmikujiEntry>> search(String keyword) async {
    final db = await database;

    final lowerKeyword = '%${keyword.toLowerCase()}%';

    final result = await db.rawQuery('''
SELECT * FROM omikuji_entries
WHERE LOWER(shrineName) LIKE ?
   OR LOWER(ocrTextRaw) LIKE ?
   OR LOWER(userMemo) LIKE ?
   OR LOWER(parsedJson) LIKE ?
ORDER BY createdAt DESC
''', [lowerKeyword, lowerKeyword, lowerKeyword, lowerKeyword]);

    return result.map((map) => _fromMap(map)).toList();
  }

  /// Get statistics
  Future<Map<String, int>> getStats() async {
    final db = await database;

    final totalCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM omikuji_entries'),
    ) ?? 0;

    final favoriteCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM omikuji_entries WHERE isFavorite = 1',
      ),
    ) ?? 0;

    return {
      'total': totalCount,
      'favorites': favoriteCount,
    };
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Convert OmikujiEntry to Map for SQLite
  Map<String, dynamic> _toMap(OmikujiEntry entry) {
    return {
      'id': entry.id,
      'createdAt': entry.createdAt.toIso8601String(),
      'shrineName': entry.shrineName,
      'imageLocalPath': entry.imageLocalPath,
      'ocrTextRaw': entry.ocrTextRaw,
      'parsedJson': jsonEncode(entry.parsedJson.toJson()),
      'userMemo': entry.userMemo,
      'tags': jsonEncode(entry.tags),
      'version': entry.version,
      'updatedAt': entry.updatedAt?.toIso8601String(),
      'isFavorite': entry.isFavorite ? 1 : 0,
    };
  }

  /// Convert Map from SQLite to OmikujiEntry
  OmikujiEntry _fromMap(Map<String, dynamic> map) {
    return OmikujiEntry(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      shrineName: map['shrineName'] as String?,
      imageLocalPath: map['imageLocalPath'] as String,
      ocrTextRaw: map['ocrTextRaw'] as String,
      parsedJson: FortuneAnalysis.fromJson(
        jsonDecode(map['parsedJson'] as String) as Map<String, dynamic>,
      ),
      userMemo: map['userMemo'] as String?,
      tags: (jsonDecode(map['tags'] as String) as List<dynamic>)
          .cast<String>(),
      version: map['version'] as int,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isFavorite: (map['isFavorite'] as int) == 1,
    );
  }
}
