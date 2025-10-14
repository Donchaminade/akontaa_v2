import 'dart:ui';
import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/providers/debt_provider.dart';
import 'package:akontaa/providers/locale_provider.dart';
import 'package:akontaa/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  final Function(ThemeMode) changeTheme;
  const SettingsPage({super.key, required this.changeTheme});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false; // Initialize directly
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    // Get the combined status (app setting AND platform permission)
    final areEnabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = areEnabled;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final localizations = AppLocalizations.of(context)!;
    if (value) {
      // User wants to enable notifications, request platform permissions
      final bool granted = await _notificationService.requestPermissions();
      if (!granted) {
        // Permissions denied, show a message and don't enable the switch
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(localizations.autorisationDeNotificationRefusee)),
          );
        }
        setState(() {
          _notificationsEnabled = false; // Keep it disabled
        });
        return;
      }
    }

    // If permissions are granted (or not enabling), proceed with app setting
    setState(() {
      _notificationsEnabled = value;
    });
    await _notificationService.setNotificationsEnabled(value);

    if (value) {
      final debtProvider = Provider.of<DebtProvider>(context, listen: false);
      await _notificationService.rescheduleAllNotifications(debtProvider.debts);
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }

  void _showResetDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            title: Text(localizations.reinitialiserLesDonnees),
            content: Text(localizations.etesVousSurDeVouloirSupprimerLesDonnees),
            actions: <Widget>[
              TextButton(
                child: Text(localizations.annuler),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(localizations.mesDettesSeulement),
                onPressed: () {
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  debtProvider.clearMyDebts();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(localizations.onMeDoitSeulement),
                onPressed: () {
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  debtProvider.clearOwedToMeDebts();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(localizations.toutSupprimer),
                onPressed: () {
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  debtProvider.clearAllDebts();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(localizations.parametres),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text(localizations.activerLesNotifications),
              secondary: const Icon(Icons.notifications),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(localizations.theme),
              trailing: DropdownButton<ThemeMode>(
                value: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    widget.changeTheme(newMode);
                  }
                },
                items: <DropdownMenuItem<ThemeMode>>[
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.light,
                    child: Text(localizations.clair),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.dark,
                    child: Text(localizations.sombre),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(localizations.langue),
              trailing: DropdownButton<String>(
                value: Provider.of<LocaleProvider>(context).locale?.languageCode ?? 'fr',
                onChanged: (String? newLocale) {
                  if (newLocale != null) {
                    Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(newLocale));
                  }
                },
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: 'fr',
                    child: Text('Français'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.restore),
              title: Text(localizations.reinitialiserLApplication),
              onTap: _showResetDialog,
            ),
          ),
        ],
      ),
    );
  }
}
