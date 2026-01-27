import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (kIsWeb) return; 
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      // إعداد المنطقة الزمنية الرياض
      tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
    } catch (e) {
      debugPrint('Timezone error: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    await _requestPermissions();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;
    
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleMorningDhikrNotification() async {
    if (kIsWeb) return;
    await _notifications.zonedSchedule(
      1,
      '🌅 حان وقت أذكار الصباح',
      'نوّر يومك بذكر الله، ابدأ صباحك بالأذكار المباركة',
      _nextInstanceOfTime(6, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel', 'أذكار الصباح',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning_dhikr',
    );
  }

  Future<void> scheduleEveningDhikrNotification() async {
    if (kIsWeb) return;
    await _notifications.zonedSchedule(
      2,
      '🌙 حان وقت أذكار المساء',
      'اختم يومك بذكر الله، أذكار المساء تحميك وتبارك لك',
      _nextInstanceOfTime(17, 30),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel', 'أذكار المساء',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_dhikr',
    );
  }

  Future<void> showInstantNotification({required String title, required String body}) async {
    if (kIsWeb) return;
    await _notifications.show(
      0, title, body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant', 'فوري', 
          importance: Importance.max, 
          priority: Priority.high
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _notifications.cancelAll();
  }
}