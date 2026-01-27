import '../models/dhikr_model.dart';
import '../data/dhikr_data.dart';
import 'database_service.dart';

class StatisticsService {
  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  final DatabaseService _db = DatabaseService();

  // حساب إجمالي الأذكار المكتملة
  Future<int> getTotalCompletedCount(List<Dhikr> allDhikr) async {
    int total = 0;
    for (var dhikr in allDhikr) {
      total += dhikr.currentCount;
    }
    return total;
  }

  // حساب إجمالي الأذكار المستهدفة
  Future<int> getTotalTargetCount() async {
    final allDhikr = DhikrData.getAllDhikr();
    int total = 0;
    for (var dhikr in allDhikr) {
      total += dhikr.targetCount;
    }
    return total;
  }

  // حساب نسبة الإنجاز الكلية
  Future<double> getOverallProgress(
    int totalCompleted,
    int totalTarget,
  ) async {
    if (totalTarget == 0) return 0.0;
    return (totalCompleted / totalTarget).clamp(0.0, 1.0);
  }

  // حساب إحصائيات كل فئة
  Future<Map<String, Map<String, dynamic>>> getCategoryStatistics(
    List<Dhikr> morningDhikr,
    List<Dhikr> eveningDhikr,
    List<Dhikr> tasbeehDhikr,
  ) async {
    return {
      'morning': _calculateCategoryStats(morningDhikr),
      'evening': _calculateCategoryStats(eveningDhikr),
      'tasbeeh': _calculateCategoryStats(tasbeehDhikr),
    };
  }

  Map<String, dynamic> _calculateCategoryStats(List<Dhikr> dhikrList) {
    int completed = 0;
    int target = 0;
    int fullyCompletedCount = 0;

    for (var dhikr in dhikrList) {
      completed += dhikr.currentCount;
      target += dhikr.targetCount;
      if (dhikr.isFullyCompleted) {
        fullyCompletedCount++;
      }
    }

    return {
      'completed': completed,
      'target': target,
      'progress': target > 0 ? completed / target : 0.0,
      'fullyCompletedCount': fullyCompletedCount,
      'totalItems': dhikrList.length,
    };
  }

  // حفظ إحصائيات اليوم
  Future<void> saveTodayStats(
    int totalCompleted,
    int totalTarget,
    double progress,
    Map<String, Map<String, dynamic>> categoryStats,
  ) async {
    final streak = await _db.calculateStreak();
    
    await _db.saveDailyStats(
      totalDhikrCount: totalCompleted,
      completionPercentage: progress * 100,
      streakDays: streak,
    );

    await _db.saveWeeklyAchievement(
      totalCompleted: totalCompleted,
      totalTarget: totalTarget,
      progress: progress,
      morningCompleted: categoryStats['morning']!['completed'],
      eveningCompleted: categoryStats['evening']!['completed'],
      tasbeehCompleted: categoryStats['tasbeeh']!['completed'],
    );
  }

  // جلب سلسلة الأيام المتتالية
  Future<int> getCurrentStreak() async {
    return await _db.calculateStreak();
  }

  // جلب إحصائيات الأسبوع
  Future<List<Map<String, dynamic>>> getWeeklyStats() async {
    return await _db.getWeeklyAchievements();
  }

  // تحقق من إكمال جميع الأذكار
  bool isAllDhikrCompleted(List<Dhikr> allDhikr) {
    for (var dhikr in allDhikr) {
      if (!dhikr.isFullyCompleted) {
        return false;
      }
    }
    return true;
  }

  // حساب النسبة المئوية لكل فئة
  Map<String, double> getCategoryPercentages(
    List<Dhikr> morningDhikr,
    List<Dhikr> eveningDhikr,
    List<Dhikr> tasbeehDhikr,
  ) {
    return {
      'morning': _getCategoryPercentage(morningDhikr),
      'evening': _getCategoryPercentage(eveningDhikr),
      'tasbeeh': _getCategoryPercentage(tasbeehDhikr),
    };
  }

  double _getCategoryPercentage(List<Dhikr> dhikrList) {
    if (dhikrList.isEmpty) return 0.0;
    
    int completed = 0;
    int target = 0;

    for (var dhikr in dhikrList) {
      completed += dhikr.currentCount;
      target += dhikr.targetCount;
    }

    return target > 0 ? (completed / target) * 100 : 0.0;
  }
}
