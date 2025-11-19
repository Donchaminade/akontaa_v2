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

  /// No description provided for @ajouterUneDette.
  ///
  /// In en, this message translates to:
  /// **'Add a debt'**
  String get ajouterUneDette;

  /// No description provided for @modifierLaDette.
  ///
  /// In en, this message translates to:
  /// **'Edit debt'**
  String get modifierLaDette;

  /// No description provided for @nomDeLaPersonne.
  ///
  /// In en, this message translates to:
  /// **'Person\'s name'**
  String get nomDeLaPersonne;

  /// No description provided for @veuillezEntrerUnNom.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get veuillezEntrerUnNom;

  /// No description provided for @montantTotal.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get montantTotal;

  /// No description provided for @veuillezEntrerUnMontantValide.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get veuillezEntrerUnMontantValide;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @dateEcheance.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dateEcheance;

  /// No description provided for @onMeDoitCetArgent.
  ///
  /// In en, this message translates to:
  /// **'This money is owed to me'**
  String get onMeDoitCetArgent;

  /// No description provided for @parDefautUneDetteQueJeDois.
  ///
  /// In en, this message translates to:
  /// **'By default, this is a debt I owe'**
  String get parDefautUneDetteQueJeDois;

  /// No description provided for @rembourserPerson.
  ///
  /// In en, this message translates to:
  /// **'Repay {personName}'**
  String rembourserPerson(String personName);

  /// No description provided for @montantDuRemboursement.
  ///
  /// In en, this message translates to:
  /// **'Repayment amount'**
  String get montantDuRemboursement;

  /// No description provided for @montantInvalide.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount.'**
  String get montantInvalide;

  /// No description provided for @leMontantNePeutPasDepasserLeSoldeRestant.
  ///
  /// In en, this message translates to:
  /// **'The amount cannot exceed the remaining balance ({remainingAmount} Fcfa).'**
  String leMontantNePeutPasDepasserLeSoldeRestant(String remainingAmount);

  /// No description provided for @notesOptionnel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptionnel;

  /// No description provided for @selectionnerUneDetteARembourser.
  ///
  /// In en, this message translates to:
  /// **'Select a debt to repay'**
  String get selectionnerUneDetteARembourser;

  /// No description provided for @vousNavezAucuneDetteEnCours.
  ///
  /// In en, this message translates to:
  /// **'You have no outstanding debts.'**
  String get vousNavezAucuneDetteEnCours;

  /// No description provided for @ajouterUnRemboursement.
  ///
  /// In en, this message translates to:
  /// **'Add a repayment'**
  String get ajouterUnRemboursement;

  /// No description provided for @montant.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get montant;

  /// No description provided for @leMontantNePeutPasDepasserLeSoldeRestantSimple.
  ///
  /// In en, this message translates to:
  /// **'The amount cannot exceed the remaining balance.'**
  String get leMontantNePeutPasDepasserLeSoldeRestantSimple;

  /// No description provided for @confirmerLaSuppression.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmerLaSuppression;

  /// No description provided for @etesVousSurDeVouloirSupprimerCetteDette.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this debt?'**
  String get etesVousSurDeVouloirSupprimerCetteDette;

  /// No description provided for @supprimer.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get supprimer;

  /// No description provided for @historiqueDesRemboursements.
  ///
  /// In en, this message translates to:
  /// **'Repayment history'**
  String get historiqueDesRemboursements;

  /// No description provided for @montantTotalDeuxPoints.
  ///
  /// In en, this message translates to:
  /// **'Total amount:'**
  String get montantTotalDeuxPoints;

  /// No description provided for @montantRestantDeuxPoints.
  ///
  /// In en, this message translates to:
  /// **'Remaining amount:'**
  String get montantRestantDeuxPoints;

  /// No description provided for @dateEcheanceDeuxPoints.
  ///
  /// In en, this message translates to:
  /// **'Due date:'**
  String get dateEcheanceDeuxPoints;

  /// No description provided for @statutDeuxPoints.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statutDeuxPoints;

  /// No description provided for @rembourse.
  ///
  /// In en, this message translates to:
  /// **'Repaid'**
  String get rembourse;

  /// No description provided for @enCours.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get enCours;

  /// No description provided for @aucunRemboursementPourLeMoment.
  ///
  /// In en, this message translates to:
  /// **'No repayments yet.'**
  String get aucunRemboursementPourLeMoment;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @fermer.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get fermer;

  /// No description provided for @tableauDeBord.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tableauDeBord;

  /// No description provided for @paiementsParPersonne.
  ///
  /// In en, this message translates to:
  /// **'Payments by person'**
  String get paiementsParPersonne;

  /// No description provided for @bienvenueSurAkontaa.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Akontaa!'**
  String get bienvenueSurAkontaa;

  /// No description provided for @ceciEstLeTitreDeLApplication.
  ///
  /// In en, this message translates to:
  /// **'This is the application title. It indicates the current page.'**
  String get ceciEstLeTitreDeLApplication;

  /// No description provided for @accedezAuxParametresDeLApplicationIci.
  ///
  /// In en, this message translates to:
  /// **'Access the application settings here.'**
  String get accedezAuxParametresDeLApplicationIci;

  /// No description provided for @vueDEnsembleDeVosDettesEtCreances.
  ///
  /// In en, this message translates to:
  /// **'Overview of your debts and receivables.'**
  String get vueDEnsembleDeVosDettesEtCreances;

  /// No description provided for @gerezLArgentQueVousDevez.
  ///
  /// In en, this message translates to:
  /// **'Manage the money you owe.'**
  String get gerezLArgentQueVousDevez;

  /// No description provided for @gerezLArgentQueLonVousDoit.
  ///
  /// In en, this message translates to:
  /// **'Manage the money owed to you.'**
  String get gerezLArgentQueLonVousDoit;

  /// No description provided for @paiements.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paiements;

  /// No description provided for @historiqueDeTousLesPaiements.
  ///
  /// In en, this message translates to:
  /// **'History of all payments.'**
  String get historiqueDeTousLesPaiements;

  /// No description provided for @passer.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get passer;

  /// No description provided for @dash.
  ///
  /// In en, this message translates to:
  /// **'Dash'**
  String get dash;

  /// No description provided for @vousNavezAucuneDettePourLeMoment.
  ///
  /// In en, this message translates to:
  /// **'You have no debts at the moment.'**
  String get vousNavezAucuneDettePourLeMoment;

  /// No description provided for @personneNeVousDoitDArgent.
  ///
  /// In en, this message translates to:
  /// **'Nobody owes you money.'**
  String get personneNeVousDoitDArgent;

  /// No description provided for @historiqueDesTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get historiqueDesTransactions;

  /// No description provided for @typeDette.
  ///
  /// In en, this message translates to:
  /// **'Type: Debt'**
  String get typeDette;

  /// No description provided for @personne.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get personne;

  /// No description provided for @typeRemboursement.
  ///
  /// In en, this message translates to:
  /// **'Type: Repayment'**
  String get typeRemboursement;

  /// No description provided for @aDe.
  ///
  /// In en, this message translates to:
  /// **'To/From'**
  String get aDe;

  /// No description provided for @notesPreuve.
  ///
  /// In en, this message translates to:
  /// **'Notes/Proof'**
  String get notesPreuve;

  /// No description provided for @aucune.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get aucune;

  /// No description provided for @aucuneTransactionAImprimer.
  ///
  /// In en, this message translates to:
  /// **'No transactions to print.'**
  String get aucuneTransactionAImprimer;

  /// No description provided for @imprimerLHistorique.
  ///
  /// In en, this message translates to:
  /// **'Print history'**
  String get imprimerLHistorique;

  /// No description provided for @toutesLesTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get toutesLesTransactions;

  /// No description provided for @aucuneTransactionCorrespondanteAImprimer.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions to print.'**
  String get aucuneTransactionCorrespondanteAImprimer;

  /// No description provided for @dettes.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get dettes;

  /// No description provided for @aucuneDetteAAfficher.
  ///
  /// In en, this message translates to:
  /// **'No debts to display.'**
  String get aucuneDetteAAfficher;

  /// No description provided for @totalRembourse.
  ///
  /// In en, this message translates to:
  /// **'Total repaid'**
  String get totalRembourse;

  /// No description provided for @solde.
  ///
  /// In en, this message translates to:
  /// **'Paid off'**
  String get solde;

  /// No description provided for @reste.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get reste;

  /// No description provided for @detteDescription.
  ///
  /// In en, this message translates to:
  /// **'Debt: {description} - {totalAmount} Fcfa'**
  String detteDescription(String description, String totalAmount);

  /// No description provided for @echeance.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get echeance;

  /// No description provided for @remboursement.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get remboursement;

  /// No description provided for @aucunRemboursementEnregistrePourCetteDette.
  ///
  /// In en, this message translates to:
  /// **'No repayment recorded for this debt.'**
  String get aucunRemboursementEnregistrePourCetteDette;

  /// No description provided for @evenements.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get evenements;

  /// No description provided for @aucunEvenementPourLeMoment.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get aucunEvenementPourLeMoment;

  /// No description provided for @coutTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get coutTotal;

  /// No description provided for @ajouterUnEvenement.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get ajouterUnEvenement;

  /// No description provided for @modifierUnEvenement.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get modifierUnEvenement;

  /// No description provided for @nomDeLEvenement.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get nomDeLEvenement;

  /// No description provided for @ajouterUnArticle.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get ajouterUnArticle;

  /// No description provided for @modifierUnArticle.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get modifierUnArticle;

  /// No description provided for @nomDeLArticle.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get nomDeLArticle;

  /// No description provided for @cout.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cout;

  /// No description provided for @veuillezEntrerUnCoutValide.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid cost.'**
  String get veuillezEntrerUnCoutValide;

  /// No description provided for @aucunArticleDansCetEvenement.
  ///
  /// In en, this message translates to:
  /// **'No items in this event.'**
  String get aucunArticleDansCetEvenement;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @methodeDePaiement.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get methodeDePaiement;

  /// No description provided for @especes.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get especes;

  /// No description provided for @virementBancaire.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get virementBancaire;

  /// No description provided for @paiementMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Payment'**
  String get paiementMobile;

  /// No description provided for @cheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get cheque;

  /// No description provided for @referenceDeTransactionOptionnel.
  ///
  /// In en, this message translates to:
  /// **'Transaction Reference (Optional)'**
  String get referenceDeTransactionOptionnel;

  /// No description provided for @dateDePaiement.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get dateDePaiement;

  /// No description provided for @preuvePhoto.
  ///
  /// In en, this message translates to:
  /// **'Proof (Photo)'**
  String get preuvePhoto;

  /// No description provided for @veuillezSelectionnerMethodePaiement.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method.'**
  String get veuillezSelectionnerMethodePaiement;
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
