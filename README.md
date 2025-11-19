# Akontaa : Votre Gestionnaire de Dettes et Créances Local

## 🚀 Présentation du Projet

Akontaa est une application mobile Flutter intuitive conçue pour simplifier la gestion de vos dettes personnelles et des montants qui vous sont dus. Que ce soit pour des transactions informelles entre amis, en famille, ou pour des partages de dépenses lors d'événements, Akontaa vous aide à garder une trace claire de toutes vos obligations financières locales.

## 🎯 Problème Résolu

Dans notre quotidien, il est facile de perdre le fil des petits montants prêtés ou empruntés, surtout lorsque les transactions ne sont pas formalisées. Akontaa vient résoudre ce problème en offrant une plateforme centralisée et facile d'utilisation pour :

*   **Éviter les oublis :** Ne manquez plus jamais un remboursement ou un paiement dû.
*   **Clarifier les situations :** Sachez exactement qui vous doit quoi, et à qui vous devez.
*   **Simplifier le suivi :** Un historique clair et des outils de preuve pour chaque transaction.

## ✨ Fonctionnalités Clés

Akontaa est riche en fonctionnalités pour une gestion financière efficace :

*   **Gestion Complète des Dettes et Créances :**
    *   Ajoutez et modifiez facilement les dettes (ce que vous devez) et les créances (ce qu'on vous doit).
    *   Enregistrez le nom de la personne, le montant total, une description, et la date d'échéance.
*   **Suivi Détaillé des Remboursements :**
    *   Enregistrez les remboursements partiels ou complets.
    *   **Nouveau :** Incluez la méthode de paiement (espèces, virement, mobile money, chèque), la date exacte du paiement, des notes optionnelles et, surtout, **joignez une image de preuve (reçu, capture d'écran, etc.)**.
    *   Visualisez l'historique de tous les remboursements pour chaque dette.
*   **Gestion d'Événements (Partage de Coûts) :**
    *   Créez des événements et ajoutez des articles avec leurs coûts.
    *   Idéal pour le partage de dépenses entre plusieurs personnes.
*   **Historique des Transactions Intelligent :**
    *   Consultez un historique clair et filtrable de toutes vos dettes, créances et remboursements.
    *   Filtrez par "Mes dettes" ou "On me doit".
    *   **Nouveau :** Affichage amélioré avec regroupement par personne et une barre de progression visuelle pour le statut des remboursements.
*   **Export PDF :**
    *   Générez et partagez des rapports PDF de votre historique de transactions, avec des options de filtrage.
*   **Interface Utilisateur Moderne et Intuitive :**
    *   Design épuré et professionnel, inspiré des standards iOS et Android.
    *   Adaptation parfaite aux modes clair et sombre.
    *   Navigation fluide et facile à prendre en main.
*   **Personnalisation et Localisation :**
    *   Support multilingue (Français, Anglais).
    *   Gestion des thèmes (clair/sombre).
*   **Notification et Rappels (si implémenté) :**
    *   Recevez des rappels pour les dettes et créances à venir.
*   **Persistance des Données :**
    *   Toutes vos données sont sauvegardées localement sur votre appareil.

## 🛠 Technologies Utilisées

*   **Flutter SDK :** Framework de développement d'applications mobiles multiplateforme.
*   **Provider :** Pour une gestion d'état efficace et simple.
*   **Image Picker :** Pour la sélection d'images (preuves de paiement).
*   **Syncfusion Flutter DatePicker :** Pour un sélecteur de date élégant et personnalisable.
*   **intl :** Pour la gestion de l'internationalisation et le formatage des dates/devises.
*   **pdf & printing :** Pour la génération et le partage de documents PDF.
*   **shared_preferences :** Pour la persistance locale des données.
*   **uuid :** Pour la génération d'identifiants uniques.
*   **flutter_native_splash :** Pour un écran de démarrage personnalisé.
*   **tutorial_coach_mark :** Pour guider les nouveaux utilisateurs.

## 🚀 Installation et Démarrage

Pour obtenir une copie locale fonctionnelle du projet, suivez ces étapes.

### Prérequis

*   Flutter SDK installé ([guide d'installation](https://flutter.dev/docs/get-started/install))
*   Un éditeur de code (VS Code, Android Studio)

### Étapes

1.  **Clonez le dépôt :**
    ```bash
    git clone [https://github.com/Donchaminade/akontaa_v2.git]
    cd akontaa_v2
    ```
2.  **Installez les dépendances :**
    ```bash
    flutter pub get
    ```
3.  **Générez les fichiers de localisation (si nécessaire) :**
    ```bash
    flutter gen-l10n
    ```
4.  **Lancez l'application :**
    ```bash
    flutter run
    ```

## 📝 Utilisation

L'application est conçue pour être intuitive. Naviguez entre les sections "Mes Dettes", "On me doit", "Historique" et "Événements" via la barre de navigation inférieure. Utilisez le bouton `+` en haut à droite sur les écrans pertinents pour ajouter de nouvelles dettes, créances ou événements.

## 🤝 Contribution (Optionnel)

Les contributions sont les bienvenues ! Si vous avez des suggestions ou souhaitez améliorer le projet, n'hésitez pas à ouvrir une issue ou à soumettre une pull request.

## 📄 Licence (Optionnel)

Ce projet est sous licence [MIT] - voir le fichier `LICENSE.md` pour plus de détails.

## 📞 Contact (Optionnel)

Pour toute question, n'hésitez pas à me contacter à [chaminade.dondah.adjolou@gmail.com].

---

**Développé avec ❤️ par [Donchaminade]**