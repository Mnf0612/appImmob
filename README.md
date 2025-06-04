# Real Estate Application

Une application immobilière moderne construite avec Flutter et Supabase.

## Prérequis

- Flutter SDK (>=3.0.0)
- Compte Supabase
- Variables d'environnement configurées

## Configuration

1. Créez un fichier `.env` à la racine du projet avec les variables suivantes :

```env
SUPABASE_URL=votre_url_supabase
SUPABASE_ANON_KEY=votre_clé_anon_supabase
```

2. Installez les dépendances :

```bash
flutter pub get
```

## Structure du Projet

```
lib/
├── features/
│   ├── auth/
│   │   └── screens/
│   │       └── login_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart
│   └── property_listing/
│       ├── screens/
│       │   └── add_property_screen.dart
│       └── widgets/
│           └── property_card.dart
├── models/
│   └── property.dart
└── main.dart
```

## Fonctionnalités

- 📱 Interface utilisateur moderne et responsive
- 🏠 Affichage des propriétés immobilières
- 👤 Authentification des agents immobiliers
- ➕ Ajout de nouvelles propriétés
- 🌟 Système de mise en avant des propriétés

## Base de Données

La base de données Supabase comprend deux tables principales :
- `properties` : Stockage des annonces immobilières
- `agents` : Gestion des agents immobiliers

## Sécurité

- Row Level Security (RLS) activé sur toutes les tables
- Politiques d'accès configurées pour :
  - Lecture publique des propriétés
  - Création/modification réservée aux agents authentifiés

## Déploiement

1. Assurez-vous que toutes les variables d'environnement sont correctement configurées
2. Exécutez les tests :
```bash
flutter test
```
3. Construisez l'application :
```bash
flutter build web
```

## Développement Local

Pour lancer l'application en mode développement :

```bash
flutter run -d chrome
```

## License

MIT