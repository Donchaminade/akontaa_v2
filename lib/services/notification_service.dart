import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

import '../models/debt.dart';
import '../providers/debt_provider.dart'; // Import DebtProvider

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const int _dailyReminderNotificationId =
      0; // A fixed ID for the daily reminder

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false, // We will request explicitly
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<bool> _checkPlatformNotificationPermission() async {
    // For Android, check if notifications are enabled for the app
    final bool? androidGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    // For iOS, request permissions and check the result
    // This will also prompt the user if permissions are not yet determined.
    final bool? iOSGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return (androidGranted ?? false) || (iOSGranted ?? false);
  }

  Future<bool> requestPermissions() async {
    final bool? androidGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final bool? iOSGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return (androidGranted ?? false) || (iOSGranted ?? false);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final bool appSettingEnabled =
        prefs.getBool(_notificationsEnabledKey) ?? true;
    final bool platformPermissionGranted =
        await _checkPlatformNotificationPermission();
    return appSettingEnabled && platformPermissionGranted;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  int _generateIntId(String id) {
    return id.hashCode & 0x7FFFFFFF;
  }

  Future<void> scheduleDueDateNotification(Debt debt) async {
    if (!await areNotificationsEnabled() ||
        debt.isPaid ||
        debt.dueDate.isBefore(DateTime.now())) {
      return;
    }

    final int notificationId = _generateIntId(debt.id);
    final String title = debt.isOwedToMe
        ? 'Créance arrivant à échéance'
        : 'Dette arrivant à échéance';
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
            channelDescription:
                'Notifications pour les dates d\'échéance des dettes',
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
    await cancelNotification(_dailyReminderNotificationId
        .toString()); // Cancel previous daily reminder
    if (await areNotificationsEnabled()) {
      for (final debt in debts) {
        await scheduleDueDateNotification(debt);
      }
      // Schedule the daily reminder after individual debt notifications
      await scheduleDailyDebtReminder(debts);
    }
  }

  Future<void> scheduleDailyDebtReminder(List<Debt> allDebts) async {
    if (!await areNotificationsEnabled()) {
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 7, 0, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final upcomingDebts = allDebts.where((debt) {
      final difference = debt.dueDate.difference(now).inDays;
      return !debt.isPaid &&
          (difference >= 0 && difference <= 7 || difference < 0);
    }).toList();

    if (upcomingDebts.isEmpty) {
      // If no upcoming or overdue debts, just schedule a generic reminder
      await flutterLocalNotificationsPlugin.zonedSchedule(
        _dailyReminderNotificationId,
        'Rappel quotidien Akontaa',
        'Aucune dette à venir ou en retard pour le moment.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Rappels quotidiens',
            channelDescription: 'Rappels quotidiens pour les dettes',
            importance: Importance.low,
            priority: Priority.low,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      // Construct a detailed message for upcoming/overdue debts
      String title = 'Rappel de dettes Akontaa';
      String body = 'Vous avez des dettes à gérer:\n';

      for (var debt in upcomingDebts) {
        final diffDays = debt.dueDate.difference(now).inDays;
        if (diffDays < 0) {
          body +=
              '- ${debt.personName} : ${debt.remainingAmount.toStringAsFixed(0)} Fcfa (en retard de ${diffDays.abs()} jours)\n';
        } else if (diffDays == 0) {
          body +=
              '- ${debt.personName} : ${debt.remainingAmount.toStringAsFixed(0)} Fcfa (aujourd\'hui)\n';
        } else {
          body +=
              '- ${debt.personName} : ${debt.remainingAmount.toStringAsFixed(0)} Fcfa (dans $diffDays jours)\n';
        }
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _dailyReminderNotificationId,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Rappels quotidiens',
            channelDescription: 'Rappels quotidiens pour les dettes',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation:
                BigTextStyleInformation(''), // To show full body text
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    ;
  }
}
