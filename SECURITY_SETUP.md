# Configuration des Secrets et Sécurité

Ce document explique comment configurer les secrets et clés API pour le projet Imako.

## ⚠️ IMPORTANT : Sécurité

Les fichiers suivants contiennent des informations sensibles et ne doivent **JAMAIS** être commités dans Git :

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`
- `lib/core/config/env_config.dart`
- Tout fichier `.env`

## Configuration Firebase

### 1. Configuration Android

1. Téléchargez le fichier `google-services.json` depuis la console Firebase
2. Placez-le dans `android/app/google-services.json`
3. Utilisez le fichier `android/app/google-services.json.example` comme référence

### 2. Configuration iOS

1. Téléchargez le fichier `GoogleService-Info.plist` depuis la console Firebase
2. Placez-le dans `ios/Runner/GoogleService-Info.plist`
3. Utilisez le fichier `ios/Runner/GoogleService-Info.plist.example` comme référence

### 3. Configuration FlutterFire

1. Installez FlutterFire CLI : `dart pub global activate flutterfire_cli`
2. Exécutez : `flutterfire configure`
3. Cela générera automatiquement `lib/firebase_options.dart`
4. Utilisez le fichier `lib/firebase_options.dart.example` comme référence

## Configuration MinIO

1. Modifiez `lib/core/config/env_config.dart` avec vos vraies valeurs
2. Utilisez le fichier `lib/core/config/env_config.dart.example` comme référence

```dart
class EnvConfig {
  static const String minioEndpoint = 'votre-endpoint-minio';
  static const String minioPort = '9000';
  static const String minioAccessKey = 'votre-access-key';
  static const String minioSecretKey = 'votre-secret-key';
  static const String minioBucketName = 'votre-bucket';
  static const bool minioUseSsl = false;
  static const String minioPublicUrl = 'http://votre-endpoint:9000';
}
```

## Variables d'Environnement

Si vous utilisez des fichiers `.env`, créez un fichier `.env.example` avec la structure :

```env
# Firebase
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id

# MinIO
MINIO_ENDPOINT=your_endpoint
MINIO_ACCESS_KEY=your_access_key
MINIO_SECRET_KEY=your_secret_key

# Autres services
API_BASE_URL=your_api_url
```

## Clés de Signature (Production)

### Android
- Placez vos fichiers `.keystore` ou `.jks` dans `android/app/`
- Créez `android/key.properties` avec vos informations de signature

### iOS
- Placez vos certificats `.p12` et profils `.mobileprovision` dans `ios/Runner/`

## Vérification

Après configuration, vérifiez que :

1. Les fichiers sensibles ne sont pas trackés par Git :
   ```bash
   git status
   ```

2. Les fichiers d'exemple sont bien présents pour les autres développeurs

3. L'application se compile et fonctionne correctement

## Support

En cas de problème, consultez :
- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation FlutterFire](https://firebase.flutter.dev/)
- [Documentation MinIO](https://docs.min.io/) 