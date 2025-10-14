import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Akontaa'**
  String get appTitle;

  /// No description provided for @onMeDoit.
  ///
  /// In en, this message translates to:
  /// **'Owed to me'**
  String get onMeDoit;

  /// No description provided for @mesDettes.
  ///
  /// In en, this message translates to:
  /// **'My debts'**
  String get mesDettes;

  /// No description provided for @ajouter.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get ajouter;

  /// No description provided for @rembourser.
  ///
  /// In en, this message translates to:
  /// **'Repay'**
  String get rembourser;

  /// No description provided for @historique.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historique;

  /// No description provided for @fluxDesDettesEtRemboursements.
  ///
  /// In en, this message translates to:
  /// **'Debt and Repayment Flow'**
  String get fluxDesDettesEtRemboursements;

  /// No description provided for @activiteRecente.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get activiteRecente;

  /// No description provided for @aucuneActiviteRecente.
  ///
  /// In en, this message translates to:
  /// **'No recent activity.'**
  String get aucuneActiviteRecente;

  /// No description provided for @parametres.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get parametres;

  /// No description provided for @activerLesNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get activerLesNotifications;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @clair.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get clair;

  /// No description provided for @sombre.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get sombre;

  /// No description provided for @langue.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langue;

  /// No description provided for @reinitialiserLApplication.
  ///
  /// In en, this message translates to:
  /// **'Reset application'**
  String get reinitialiserLApplication;

  /// No description provided for @reinitialiserLesDonnees.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get reinitialiserLesDonnees;

  /// No description provided for @etesVousSurDeVouloirSupprimerLesDonnees.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the data? This action is irreversible.'**
  String get etesVousSurDeVouloirSupprimerLesDonnees;

  /// No description provided for @annuler.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get annuler;

  /// No description provided for @mesDettesSeulement.
  ///
  /// In en, this message translates to:
  /// **'My debts only'**
  String get mesDettesSeulement;

  /// No description provided for @onMeDoitSeulement.
  ///
  /// In en, this message translates to:
  /// **'Owed to me only'**
  String get onMeDoitSeulement;

  /// No description provided for @toutSupprimer.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get toutSupprimer;

  /// No description provided for @autorisationDeNotificationRefusee.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. Please enable it in your phone settings.'**
  String get autorisationDeNotificationRefusee;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
