import 'dart:ui';
import 'package:akontaa/providers/debt_provider.dart';
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
    if (value) {
      // User wants to enable notifications, request platform permissions
      final bool granted = await _notificationService.requestPermissions();
      if (!granted) {
        // Permissions denied, show a message and don't enable the switch
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Autorisation de notification refusée. Veuillez l\'activer dans les paramètres de votre téléphone.')),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            title: const Text('Réinitialiser les données'),
            content: const Text('Êtes-vous sûr de vouloir supprimer les données ? Cette action est irréversible.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Mes dettes seulement'),
                onPressed: () {
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  debtProvider.clearMyDebts();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('On me doit seulement'),
                onPressed: () {
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  debtProvider.clearOwedToMeDebts();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Tout supprimer'),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Paramètres'),
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
              title: const Text('Activer les notifications'),
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
              title: const Text('Thème'),
              trailing: DropdownButton<ThemeMode>(
                value: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    widget.changeTheme(newMode);
                  }
                },
                items: const <DropdownMenuItem<ThemeMode>>[
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.light,
                    child: Text('Clair'),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.dark,
                    child: Text('Sombre'),
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
              title: const Text('Langue'),
              trailing: const Text('Français (par défaut)'), // Placeholder for language selection
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La sélection de la langue nécessite une configuration d\'internationalisation plus approfondie.')),
                );
              },
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.restore),
              title: const Text("Réinitialiser l'application"),
              onTap: _showResetDialog,
            ),
          ),
        ],
      ),
    );
  }
}
