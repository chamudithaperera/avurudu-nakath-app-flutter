import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../features/home/domain/entities/nakath_event.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _permissionRequestedKey =
      'notification_permission_requested';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'nakath_channel_id',
    'Nakath Notifications',
    description: 'Reminders for Avurudu Nakath events',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
    } catch (e) {
      // Fallback if timezone detection fails
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Colombo'));
      } catch (e) {
        // Should not happen if data is loaded, but safe fallback
        tz.setLocalLocation(tz.local);
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.createNotificationChannel(_channel);
    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool(_permissionRequestedKey) ?? false;

    // Always check for permission status on Android 13+ even if we "asked" before
    // because the user might have denied it and we might want to show rationale or similar
    // (though for now we stick to the simple flow)

    if (alreadyAsked) return;

    if (Platform.isAndroid) {
      // Android 13+ Permission
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    await prefs.setBool(_permissionRequestedKey, true);
  }

  Future<void> scheduleNotifications(List<NakathEvent> events) async {
    await flutterLocalNotificationsPlugin.cancelAll();

    int notificationId = 0;
    final scheduleMode = await _resolveAndroidScheduleMode();

    for (var event in events) {
      if (event.start == null) continue;
      if (event.notificationPolicy == 'none') continue;

      final startTime = event.start!;

      // At Start
      await _scheduleOne(
        id: notificationId++,
        title: 'Nakath Time',
        body: 'Upcoming auspicious time is starting now.',
        scheduledDate: startTime,
        scheduleMode: scheduleMode,
      );

      // Minus 5
      if (event.notificationPolicy == 'atStartAndMinus5') {
        final minus5 = startTime.subtract(const Duration(minutes: 5));
        await _scheduleOne(
          id: notificationId++,
          title: 'Nakath Reminder',
          body: '5 minutes to go!',
          scheduledDate: minus5,
          scheduleMode: scheduleMode,
        );
      }
    }
  }

  Future<void> _scheduleOne({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required AndroidScheduleMode scheduleMode,
  }) async {
    final scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);
    if (scheduledTz.isBefore(tz.TZDateTime.now(tz.local))) return;

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTz,
      notificationDetails: notificationDetails,
      androidScheduleMode: scheduleMode,
    );
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    if (!Platform.isAndroid) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact = await androidImplementation
        ?.canScheduleExactNotifications();
    return (canExact ?? false)
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }
}
