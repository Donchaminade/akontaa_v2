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

  @override
  String get ajouterUneDette => 'Add a debt';

  @override
  String get modifierLaDette => 'Edit debt';

  @override
  String get nomDeLaPersonne => 'Person\'s name';

  @override
  String get veuillezEntrerUnNom => 'Please enter a name.';

  @override
  String get montantTotal => 'Total amount';

  @override
  String get veuillezEntrerUnMontantValide => 'Please enter a valid amount.';

  @override
  String get description => 'Description';

  @override
  String get dateEcheance => 'Due date';

  @override
  String get onMeDoitCetArgent => 'This money is owed to me';

  @override
  String get parDefautUneDetteQueJeDois => 'By default, this is a debt I owe';

  @override
  String rembourserPerson(String personName) {
    return 'Repay $personName';
  }

  @override
  String get montantDuRemboursement => 'Repayment amount';

  @override
  String get montantInvalide => 'Invalid amount.';

  @override
  String leMontantNePeutPasDepasserLeSoldeRestant(String remainingAmount) {
    return 'The amount cannot exceed the remaining balance ($remainingAmount Fcfa).';
  }

  @override
  String get notesOptionnel => 'Notes (optional)';

  @override
  String get selectionnerUneDetteARembourser => 'Select a debt to repay';

  @override
  String get vousNavezAucuneDetteEnCours => 'You have no outstanding debts.';

  @override
  String get ajouterUnRemboursement => 'Add a repayment';

  @override
  String get montant => 'Amount';

  @override
  String get leMontantNePeutPasDepasserLeSoldeRestantSimple =>
      'The amount cannot exceed the remaining balance.';

  @override
  String get confirmerLaSuppression => 'Confirm deletion';

  @override
  String get etesVousSurDeVouloirSupprimerCetteDette =>
      'Are you sure you want to delete this debt?';

  @override
  String get supprimer => 'Delete';

  @override
  String get historiqueDesRemboursements => 'Repayment history';

  @override
  String get montantTotalDeuxPoints => 'Total amount:';

  @override
  String get montantRestantDeuxPoints => 'Remaining amount:';

  @override
  String get dateEcheanceDeuxPoints => 'Due date:';

  @override
  String get statutDeuxPoints => 'Status:';

  @override
  String get rembourse => 'Repaid';

  @override
  String get enCours => 'In progress';

  @override
  String get aucunRemboursementPourLeMoment => 'No repayments yet.';

  @override
  String get notes => 'Notes';

  @override
  String get fermer => 'Close';

  @override
  String get tableauDeBord => 'Dashboard';

  @override
  String get paiementsParPersonne => 'Payments by person';

  @override
  String get bienvenueSurAkontaa => 'Welcome to Akontaa!';

  @override
  String get ceciEstLeTitreDeLApplication =>
      'This is the application title. It indicates the current page.';

  @override
  String get accedezAuxParametresDeLApplicationIci =>
      'Access the application settings here.';

  @override
  String get vueDEnsembleDeVosDettesEtCreances =>
      'Overview of your debts and receivables.';

  @override
  String get gerezLArgentQueVousDevez => 'Manage the money you owe.';

  @override
  String get gerezLArgentQueLonVousDoit => 'Manage the money owed to you.';

  @override
  String get paiements => 'Payments';

  @override
  String get historiqueDeTousLesPaiements => 'History of all payments.';

  @override
  String get passer => 'SKIP';

  @override
  String get dash => 'Dash';

  @override
  String get vousNavezAucuneDettePourLeMoment =>
      'You have no debts at the moment.';

  @override
  String get personneNeVousDoitDArgent => 'Nobody owes you money.';

  @override
  String get historiqueDesTransactions => 'Transaction history';

  @override
  String get typeDette => 'Type: Debt';

  @override
  String get personne => 'Person';

  @override
  String get typeRemboursement => 'Type: Repayment';

  @override
  String get aDe => 'To/From';

  @override
  String get notesPreuve => 'Notes/Proof';

  @override
  String get aucune => 'None';

  @override
  String get aucuneTransactionAImprimer => 'No transactions to print.';

  @override
  String get imprimerLHistorique => 'Print history';

  @override
  String get toutesLesTransactions => 'All transactions';

  @override
  String get aucuneTransactionCorrespondanteAImprimer =>
      'No matching transactions to print.';

  @override
  String get dettes => 'Debts';

  @override
  String get aucuneDetteAAfficher => 'No debts to display.';

  @override
  String get totalRembourse => 'Total repaid';

  @override
  String get solde => 'Paid off';

  @override
  String get reste => 'Remaining';

  @override
  String detteDescription(String description, String totalAmount) {
    return 'Debt: $description - $totalAmount Fcfa';
  }

  @override
  String get echeance => 'Due date';

  @override
  String get remboursement => 'Repayment';

  @override
  String get aucunRemboursementEnregistrePourCetteDette =>
      'No repayment recorded for this debt.';
}
