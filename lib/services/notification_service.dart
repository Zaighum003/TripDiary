

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../data/models/trip_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<bool> initializeNotifications() async {
    if (_isInitialized) return true;

    try {
        const androidSettings =
          AndroidInitializationSettings('launch_background');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _notificationsPlugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Error initializing notifications: $e');
      return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      return result ?? false;
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  Future<bool> scheduleReminder(Trip trip, DateTime reminderTime) async {
    try {
      if (!_isInitialized) {
        await initializeNotifications();
      }

      if (reminderTime.isBefore(DateTime.now())) {
        print('Reminder time is in the past');
        return false;
      }

      const androidDetails = AndroidNotificationDetails(
        'trip_reminders_channel',
        'Trip Reminders',
        channelDescription: 'Notifications for trip reminders',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        trip.id ?? 0,
        'Trip Reminder',
        '${trip.title} - Departing to ${trip.destination}',
        tz.TZDateTime.from(reminderTime, tz.local),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      print('Reminder scheduled for ${trip.title}');
      return true;
    } catch (e) {
      print('Error scheduling reminder: $e');
      return false;
    }
  }

  Future<void> cancelReminder(int tripId) async {
    try {
      await _notificationsPlugin.cancel(tripId);
      print('Reminder cancelled for trip $tripId');
    } catch (e) {
      print('Error cancelling reminder: $e');
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await _notificationsPlugin.cancelAll();
      print('All reminders cancelled');
    } catch (e) {
      print('Error cancelling all reminders: $e');
    }
  }

  Future<void> showTestNotification(String title, String body) async {
    try {
      if (!_isInitialized) {
        await initializeNotifications();
      }

      const androidDetails = AndroidNotificationDetails(
        'test_channel',
        'Test Channel',
        channelDescription: 'Test notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        999,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print('Error showing test notification: $e');
    }
  }
}
