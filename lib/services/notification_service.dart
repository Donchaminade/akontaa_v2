
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

import '../models/debt.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  int _generateIntId(String id) {
    return id.hashCode & 0x7FFFFFFF;
  }

  Future<void> scheduleDueDateNotification(Debt debt) async {
    if (!await areNotificationsEnabled() || debt.isPaid || debt.dueDate.isBefore(DateTime.now())) {
      return;
    }

    final int notificationId = _generateIntId(debt.id);
    final String title = debt.isOwedToMe ? 'Créance arrivant à échéance' : 'Dette arrivant à échéance';
    final String body =
        'Votre dette envers ${debt.personName} de ${debt.totalAmount} Fcfa arrive à échéance aujourd\'hui.';
    
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(debt.dueDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'debt_due_date_channel',
            'Notifications d\'échéance de dette',
            channelDescription: 'Notifications pour les dates d\'échéance des dettes',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la programmation de la notification: $e');
      }
    }
  }

  Future<void> cancelNotification(String debtId) async {
    final int notificationId = _generateIntId(debtId);
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> rescheduleAllNotifications(List<Debt> debts) async {
    await cancelAllNotifications();
    if (await areNotificationsEnabled()) {
      for (final debt in debts) {
        await scheduleDueDateNotification(debt);
      }
    }
  }
}

