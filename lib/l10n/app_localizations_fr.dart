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

  @override
  String get ajouterUneDette => 'Ajouter une dette';

  @override
  String get modifierLaDette => 'Modifier la dette';

  @override
  String get nomDeLaPersonne => 'Nom de la personne';

  @override
  String get veuillezEntrerUnNom => 'Veuillez entrer un nom.';

  @override
  String get montantTotal => 'Montant total';

  @override
  String get veuillezEntrerUnMontantValide =>
      'Veuillez entrer un montant valide.';

  @override
  String get description => 'Description';

  @override
  String get dateEcheance => 'Date d\'échéance';

  @override
  String get onMeDoitCetArgent => 'On me doit cet argent';

  @override
  String get parDefautUneDetteQueJeDois =>
      'Par défaut, c\'est une dette que je dois';

  @override
  String rembourserPerson(String personName) {
    return 'Rembourser $personName';
  }

  @override
  String get montantDuRemboursement => 'Montant du remboursement';

  @override
  String get montantInvalide => 'Montant invalide.';

  @override
  String leMontantNePeutPasDepasserLeSoldeRestant(String remainingAmount) {
    return 'Le montant ne peut pas dépasser le solde restant ($remainingAmount Fcfa).';
  }

  @override
  String get notesOptionnel => 'Notes (optionnel)';

  @override
  String get selectionnerUneDetteARembourser =>
      'Sélectionner une dette à rembourser';

  @override
  String get vousNavezAucuneDetteEnCours =>
      'Vous n\'avez aucune dette en cours.';

  @override
  String get ajouterUnRemboursement => 'Ajouter un remboursement';

  @override
  String get montant => 'Montant';

  @override
  String get leMontantNePeutPasDepasserLeSoldeRestantSimple =>
      'Le montant ne peut pas dépasser le solde restant.';

  @override
  String get confirmerLaSuppression => 'Confirmer la suppression';

  @override
  String get etesVousSurDeVouloirSupprimerCetteDette =>
      'Êtes-vous sûr de vouloir supprimer cette dette ?';

  @override
  String get supprimer => 'Supprimer';

  @override
  String get historiqueDesRemboursements => 'Historique des remboursements';

  @override
  String get montantTotalDeuxPoints => 'Montant total:';

  @override
  String get montantRestantDeuxPoints => 'Montant restant:';

  @override
  String get dateEcheanceDeuxPoints => 'Date d\'échéance:';

  @override
  String get statutDeuxPoints => 'Statut:';

  @override
  String get rembourse => 'Remboursé';

  @override
  String get enCours => 'En cours';

  @override
  String get aucunRemboursementPourLeMoment =>
      'Aucun remboursement pour le moment.';

  @override
  String get notes => 'Notes';

  @override
  String get fermer => 'Fermer';

  @override
  String get tableauDeBord => 'Tableau de bord';

  @override
  String get paiementsParPersonne => 'Paiements par personne';

  @override
  String get bienvenueSurAkontaa => 'Bienvenue sur Akontaa!';

  @override
  String get ceciEstLeTitreDeLApplication =>
      'Ceci est le titre de l\'application. Il indique la page actuelle.';

  @override
  String get accedezAuxParametresDeLApplicationIci =>
      'Accédez aux paramètres de l\'application ici.';

  @override
  String get vueDEnsembleDeVosDettesEtCreances =>
      'Vue d\'ensemble de vos dettes et créances.';

  @override
  String get gerezLArgentQueVousDevez => 'Gérez l\'argent que vous devez.';

  @override
  String get gerezLArgentQueLonVousDoit =>
      'Gérez l\'argent que l\'on vous doit.';

  @override
  String get paiements => 'Paiements';

  @override
  String get historiqueDeTousLesPaiements =>
      'Historique de tous les paiements.';

  @override
  String get passer => 'PASSER';

  @override
  String get dash => 'Dash';

  @override
  String get vousNavezAucuneDettePourLeMoment =>
      'Vous n\'avez aucune dette pour le moment.';

  @override
  String get personneNeVousDoitDArgent => 'Personne ne vous doit d\'argent.';

  @override
  String get historiqueDesTransactions => 'Historique des transactions';

  @override
  String get typeDette => 'Type: Dette';

  @override
  String get personne => 'Personne';

  @override
  String get typeRemboursement => 'Type: Remboursement';

  @override
  String get aDe => 'À/De';

  @override
  String get notesPreuve => 'Notes/Preuve';

  @override
  String get aucune => 'Aucune';

  @override
  String get aucuneTransactionAImprimer => 'Aucune transaction à imprimer.';

  @override
  String get imprimerLHistorique => 'Imprimer l\'historique';

  @override
  String get toutesLesTransactions => 'Toutes les transactions';

  @override
  String get aucuneTransactionCorrespondanteAImprimer =>
      'Aucune transaction correspondante à imprimer.';

  @override
  String get dettes => 'Dettes';

  @override
  String get aucuneDetteAAfficher => 'Aucune dette à afficher.';

  @override
  String get totalRembourse => 'Total remboursé';

  @override
  String get solde => 'Soldé';

  @override
  String get reste => 'Reste';

  @override
  String detteDescription(String description, String totalAmount) {
    return 'Dette: $description - $totalAmount Fcfa';
  }

  @override
  String get echeance => 'Échéance';

  @override
  String get remboursement => 'Remboursement';

  @override
  String get aucunRemboursementEnregistrePourCetteDette =>
      'Aucun remboursement enregistré pour cette dette.';

  @override
  String get evenements => 'Événements';

  @override
  String get aucunEvenementPourLeMoment => 'Aucun événement pour le moment.';

  @override
  String get coutTotal => 'Coût Total';

  @override
  String get ajouterUnEvenement => 'Ajouter un événement';

  @override
  String get modifierUnEvenement => 'Modifier l\'événement';

  @override
  String get nomDeLEvenement => 'Nom de l\'événement';

  @override
  String get ajouterUnArticle => 'Ajouter un article';

  @override
  String get modifierUnArticle => 'Modifier l\'article';

  @override
  String get nomDeLArticle => 'Nom de l\'article';

  @override
  String get cout => 'Coût';

  @override
  String get veuillezEntrerUnCoutValide => 'Veuillez entrer un coût valide.';

  @override
  String get aucunArticleDansCetEvenement =>
      'Aucun article dans cet événement.';

  @override
  String get articles => 'Articles';
}
