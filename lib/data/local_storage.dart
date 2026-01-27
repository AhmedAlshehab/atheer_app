import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr_model.dart';
import 'package:atheer/data/dhikr_data.dart'; // تأكد من صحة مسار الملف لديك

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  static const String _progressKey = 'dhikr_progress';
  static const String _firstTimeKey = 'is_first_time';

  Future<void> initializeAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeKey) ?? true;
    
    if (isFirstTime) {
      // تصفير جميع العدادات عند التشغيل الأول
      final allDhikr = DhikrData.getAllDhikr();
      final Map<String, dynamic> progressMap = {};
      
      for (var dhikr in allDhikr) {
        progressMap[dhikr.id.toString()] = {
          'currentCount': 0,
          'isCompleted': false,
          'lastUpdated': null,
        };
      }
      
      await prefs.setString(_progressKey, json.encode(progressMap));
      await prefs.setBool(_firstTimeKey, false);
    }
  }

  Future<Map<int, Map<String, dynamic>>> getProgressMap() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    
    if (progressJson == null) {
      return {};
    }
    
    final Map<String, dynamic> progressData = json.decode(progressJson);
    final Map<int, Map<String, dynamic>> result = {};
    
    progressData.forEach((key, value) {
      result[int.parse(key)] = Map<String, dynamic>.from(value);
    });
    
    return result;
  }

  Future<void> updateDhikrProgress(Dhikr dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    Map<String, dynamic> progressData = {};
    
    if (progressJson != null) {
      progressData = Map<String, dynamic>.from(json.decode(progressJson));
    }
    
    progressData[dhikr.id.toString()] = {
      'currentCount': dhikr.currentCount,
      'isCompleted': dhikr.isCompleted,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
    
    await prefs.setString(_progressKey, json.encode(progressData));
  }

  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final allDhikr = DhikrData.getAllDhikr();
    final Map<String, dynamic> progressMap = {};
    
    for (var dhikr in allDhikr) {
      progressMap[dhikr.id.toString()] = {
        'currentCount': 0,
        'isCompleted': false,
        'lastUpdated': null,
      };
    }
    
    await prefs.setString(_progressKey, json.encode(progressMap));
  }

  Future<int> getTotalCompletedCount() async {
    final progressMap = await getProgressMap();
    int total = 0;
    
    progressMap.forEach((key, value) {
      total = total + ((value['currentCount'] ?? 0) as num).toInt();
    });
    
    return total;
  }

  Future<int> getTotalDhikrCount() async {
    final allDhikr = DhikrData.getAllDhikr();
    int total = 0;
    
    for (var dhikr in allDhikr) {
      total += dhikr.targetCount.toInt();
    }
    
    return total;
  }

  Future<double> getOverallProgress() async {
    final totalCompleted = await getTotalCompletedCount();
    final totalTarget = await getTotalDhikrCount();
    
    if (totalTarget == 0) return 0.0;
    return totalCompleted / totalTarget;
  }
}