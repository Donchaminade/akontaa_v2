// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Akontaa';

  @override
  String get onMeDoit => 'On me doit';

  @override
  String get mesDettes => 'Mes dettes';

  @override
  String get ajouter => 'Ajouter';

  @override
  String get rembourser => 'Rembourser';

  @override
  String get historique => 'Historique';

  @override
  String get fluxDesDettesEtRemboursements =>
      'Flux des dettes et remboursements';

  @override
  String get activiteRecente => 'Activité récente';

  @override
  String get aucuneActiviteRecente => 'Aucune activité récente.';

  @override
  String get parametres => 'Paramètres';

  @override
  String get activerLesNotifications => 'Activer les notifications';

  @override
  String get theme => 'Thème';

  @override
  String get clair => 'Clair';

  @override
  String get sombre => 'Sombre';

  @override
  String get langue => 'Langue';

  @override
  String get reinitialiserLApplication => 'Réinitialiser l\'application';

  @override
  String get reinitialiserLesDonnees => 'Réinitialiser les données';

  @override
  String get etesVousSurDeVouloirSupprimerLesDonnees =>
      'Êtes-vous sûr de vouloir supprimer les données ? Cette action est irréversible.';

  @override
  String get annuler => 'Annuler';

  @override
  String get mesDettesSeulement => 'Mes dettes seulement';

  @override
  String get onMeDoitSeulement => 'On me doit seulement';

  @override
  String get toutSupprimer => 'Tout supprimer';

  @override
  String get autorisationDeNotificationRefusee =>
      'Autorisation de notification refusée. Veuillez l\'activer dans les paramètres de votre téléphone.';
}
