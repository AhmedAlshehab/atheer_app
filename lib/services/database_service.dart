import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dhikr_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static sqflite.Database? _database;

  Future<sqflite.Database?> get database async {
    if (kIsWeb) return null; 
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    if (kIsWeb) return null;
    final String path = join(await getDatabasesPath(), 'atheer.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE dhikr_progress (id INTEGER PRIMARY KEY, current_count INTEGER NOT NULL DEFAULT 0, is_completed INTEGER NOT NULL DEFAULT 0, last_updated TEXT)''');
    await db.execute('''CREATE TABLE weekly_achievement (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, total_completed INTEGER NOT NULL DEFAULT 0, total_target INTEGER NOT NULL DEFAULT 0, progress REAL NOT NULL DEFAULT 0.0, morning_completed INTEGER NOT NULL DEFAULT 0, evening_completed INTEGER NOT NULL DEFAULT 0, tasbeeh_completed INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE daily_stats (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL UNIQUE, total_dhikr_count INTEGER NOT NULL DEFAULT 0, completion_percentage REAL NOT NULL DEFAULT 0.0, streak_days INTEGER NOT NULL DEFAULT 0)''');
  }

  // --- دوال التقدم ---
  Future<void> saveDhikrProgress(Dhikr dhikr) async {
    if (kIsWeb) return;
    final db = await database;
    await db?.insert('dhikr_progress', {
      'id': dhikr.id,
      'current_count': dhikr.currentCount,
      'is_completed': dhikr.isFullyCompleted ? 1 : 0,
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<int, Map<String, dynamic>>> getAllDhikrProgress() async {
    if (kIsWeb) return {};
    final db = await database;
    if (db == null) return {};
    final List<Map<String, dynamic>> maps = await db.query('dhikr_progress');
    return {for (var m in maps) m['id'] as int: {'currentCount': m['current_count'], 'isCompleted': m['is_completed'] == 1, 'lastUpdated': m['last_updated']}};
  }

  Future<void> resetAllProgress() async {
    if (kIsWeb) return;
    final db = await database;
    await db?.delete('dhikr_progress');
  }

  // --- دوال الإحصائيات (التي كانت ناقصة) ---
  Future<void> saveDailyStats({required int totalDhikrCount, required double completionPercentage, required int streakDays}) async {
    if (kIsWeb) return;
    final db = await database;
    if (db == null) return;
    final today = DateTime.now().toIso8601String().split('T')[0];
    await db.insert(
      'daily_stats',
      {
        'date': today,
        'total_dhikr_count': totalDhikrCount,
        'completion_percentage': completionPercentage,
        'streak_days': streakDays
      },
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<void> saveWeeklyAchievement({
    required int totalCompleted,
    required int totalTarget,
    required double progress,
    required int morningCompleted,
    required int eveningCompleted,
    required int tasbeehCompleted,
  }) async {
    if (kIsWeb) return;
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    await db?.insert('weekly_achievement', {'date': today, 'total_completed': totalCompleted, 'total_target': totalTarget, 'progress': progress, 'morning_completed': morningCompleted, 'evening_completed': eveningCompleted, 'tasbeeh_completed': tasbeehCompleted}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getWeeklyAchievements() async {
    if (kIsWeb) return [];
    final db = await database;
    if (db == null) return [];
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return await db.query('weekly_achievement', where: 'date >= ?', whereArgs: [sevenDaysAgo.toIso8601String().split('T')[0]], orderBy: 'date DESC');
  }

  Future<Map<String, dynamic>?> getLatestDailyStats() async {
    if (kIsWeb) return null;
    final db = await database;
    final List<Map<String, dynamic>> maps = await db?.query('daily_stats', orderBy: 'date DESC', limit: 1) ?? [];
    return maps.isEmpty ? null : maps.first;
  }

  Future<int> calculateStreak() async {
    if (kIsWeb) return 0;
    final db = await database;
    if (db == null) return 0;
    final List<Map<String, dynamic>> stats = await db.query('daily_stats', where: 'completion_percentage >= 80.0', orderBy: 'date DESC');
    if (stats.isEmpty) return 0;
    
    int streak = 0;
    DateTime lastDate = DateTime.parse(stats[0]['date']);
    for (var stat in stats) {
      final date = DateTime.parse(stat['date']);
      if (lastDate.difference(date).inDays <= 1) { streak++; lastDate = date; } else break;
    }
    return streak;
  }

  Future<void> close() async {
    if (kIsWeb) return;
    final db = await database;
    await db?.close();
  }
}