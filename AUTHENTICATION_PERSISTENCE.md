# Système d'Authentification Persistante

## Vue d'ensemble

Ce système permet de maintenir l'utilisateur connecté même après la fermeture de l'application en utilisant le stockage local (SharedPreferences) pour sauvegarder les informations utilisateur.

## Architecture

### Services

#### 1. LocalStorageService
- **Fichier**: `lib/data/services/local_storage_service.dart`
- **Responsabilité**: Gestion directe du stockage local avec SharedPreferences
- **Fonctionnalités**:
  - Sauvegarder les données utilisateur
  - Récupérer les données utilisateur
  - Vérifier l'état de connexion
  - Supprimer les données utilisateur

#### 2. AuthPersistenceService
- **Fichier**: `lib/data/services/auth_persistence_service.dart`
- **Responsabilité**: Service de persistance centralisé avec gestion d'erreurs
- **Fonctionnalités**:
  - Sauvegarder l'utilisateur authentifié
  - Récupérer l'utilisateur authentifié
  - Vérifier l'authentification
  - Mettre à jour les données utilisateur
  - Synchroniser avec Firebase

### Contrôleur

#### AuthController
- **Fichier**: `lib/presentation/controllers/auth_controller.dart`
- **Responsabilité**: Gestion de l'authentification avec persistance
- **Fonctionnalités**:
  - Connexion avec sauvegarde locale
  - Inscription avec sauvegarde locale
  - Déconnexion avec nettoyage local
  - Vérification de l'état d'authentification

### Pages

#### 1. SplashPage
- **Fichier**: `lib/presentation/pages/splash_page.dart`
- **Responsabilité**: Page de démarrage qui vérifie l'état d'authentification
- **Comportement**:
  - Affiche un écran de chargement
  - Vérifie si l'utilisateur est connecté localement
  - Redirige vers HOME si connecté, sinon vers WELCOME

#### 2. RootRedirectPage
- **Fichier**: `lib/presentation/pages/root_redirect_page.dart`
- **Responsabilité**: Redirection basée sur l'état d'authentification
- **Comportement**:
  - Vérifie l'état d'authentification local et Firebase
  - Met à jour le contrôleur avec les données locales
  - Redirige vers la page appropriée

## Flux d'Authentification

### 1. Démarrage de l'Application
```
SplashPage → Vérification locale → HOME ou WELCOME
```

### 2. Connexion
```
LoginPage → Firebase Auth → Firestore → Sauvegarde locale → HOME
```

### 3. Inscription
```
RegisterPage → Firebase Auth → Firestore → Sauvegarde locale → HOME
```

### 4. Déconnexion
```
SignOut → Firebase SignOut → Nettoyage local → WELCOME
```

## Données Stockées

Les informations suivantes sont sauvegardées localement :

```json
{
  "id": "user_id",
  "email": "user@example.com",
  "userType": "particular|professional",
  "firstName": "Prénom",
  "lastName": "Nom",
  "phone": "Téléphone",
  "profileImageUrl": "URL_image",
  "companyName": "Nom_entreprise",
  "siret": "SIRET",
  "activity": "Activité",
  "address": "Adresse"
}
```

## Sécurité

- Les données sont stockées localement sur l'appareil
- Aucun mot de passe n'est stocké localement
- L'authentification Firebase reste la source de vérité
- Les données locales sont synchronisées avec Firebase

## Gestion d'Erreurs

- En cas d'erreur de récupération locale, redirection vers WELCOME
- Logs détaillés pour le débogage
- Gestion gracieuse des erreurs de stockage

## Utilisation

### Vérifier l'état d'authentification
```dart
final isAuthenticated = await AuthPersistenceService.instance.isUserAuthenticated();
```

### Récupérer l'utilisateur connecté
```dart
final user = await AuthPersistenceService.instance.getAuthenticatedUser();
```

### Sauvegarder un utilisateur
```dart
await AuthPersistenceService.instance.saveAuthenticatedUser(userModel);
```

### Déconnecter l'utilisateur
```dart
await AuthPersistenceService.instance.clearAuthentication();
```

## Configuration

### Dépendances
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

### Routes
```dart
static const INITIAL = Routes.SPLASH;
```

## Avantages

1. **Expérience utilisateur améliorée**: Pas besoin de se reconnecter à chaque ouverture
2. **Performance**: Chargement rapide des données utilisateur
3. **Fiabilité**: Synchronisation avec Firebase
4. **Maintenabilité**: Architecture modulaire et extensible
5. **Sécurité**: Pas de stockage de mots de passe locaux 