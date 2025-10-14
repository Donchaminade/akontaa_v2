// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Akontaa';

  @override
  String get onMeDoit => 'Owed to me';

  @override
  String get mesDettes => 'My debts';

  @override
  String get ajouter => 'Add';

  @override
  String get rembourser => 'Repay';

  @override
  String get historique => 'History';

  @override
  String get fluxDesDettesEtRemboursements => 'Debt and Repayment Flow';

  @override
  String get activiteRecente => 'Recent Activity';

  @override
  String get aucuneActiviteRecente => 'No recent activity.';

  @override
  String get parametres => 'Settings';

  @override
  String get activerLesNotifications => 'Enable notifications';

  @override
  String get theme => 'Theme';

  @override
  String get clair => 'Light';

  @override
  String get sombre => 'Dark';

  @override
  String get langue => 'Language';

  @override
  String get reinitialiserLApplication => 'Reset application';

  @override
  String get reinitialiserLesDonnees => 'Reset data';

  @override
  String get etesVousSurDeVouloirSupprimerLesDonnees =>
      'Are you sure you want to delete the data? This action is irreversible.';

  @override
  String get annuler => 'Cancel';

  @override
  String get mesDettesSeulement => 'My debts only';

  @override
  String get onMeDoitSeulement => 'Owed to me only';

  @override
  String get toutSupprimer => 'Delete all';

  @override
  String get autorisationDeNotificationRefusee =>
      'Notification permission denied. Please enable it in your phone settings.';
}
