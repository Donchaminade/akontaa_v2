# Akontaa - Gestion de dettes / créances (Flutter)

Ce projet minimal est un point de départ pour l'application **Akontaa** décrite par l'utilisateur.
Il utilise **Provider** pour la gestion d'état et **shared_preferences** pour le stockage local (JSON).

## Structure principale
- `lib/main.dart` - point d'entrée
- `lib/models/` - modèles (Debt, Repayment)
- `lib/services/` - StorageService (gère sauvegarde/chargement JSON)
- `lib/providers/` - DebtProvider (logique métier et état)
- `lib/pages/` - écrans (Dashboard, MyDebts, OwedToMe, Add/Edit, Detail)
- `lib/widgets/` - composants réutilisables

## Exécution
1. Assurez-vous d'avoir Flutter installé (stable).
2. Depuis le dossier du projet:
```bash
flutter pub get
flutter run
```

## Notes
- Ce projet utilise `shared_preferences` pour simplicité. Pour un projet réel et plus robuste, utilisez `hive` ou `sqflite`.
- Les modèles se sérialisent en JSON pour la persistance.
- Exemple de données initiales incluses pour tester l'interface.

Bonne continuation — si vous voulez, je peux ajouter la génération PDF, l'upload d'images de preuve, ou migration vers Hive.
