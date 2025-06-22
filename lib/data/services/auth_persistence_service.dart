import '../../data/models/user_model.dart';
import 'local_storage_service.dart';

class AuthPersistenceService {
  static AuthPersistenceService? _instance;
  static AuthPersistenceService get instance {
    _instance ??= AuthPersistenceService._internal();
    return _instance!;
  }

  AuthPersistenceService._internal();

  // Sauvegarder l'utilisateur connecté
  Future<void> saveAuthenticatedUser(UserModel user) async {
    try {
      await LocalStorageService.saveUser(user);
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'utilisateur connecté
  Future<UserModel?> getAuthenticatedUser() async {
    try {
      final isLoggedIn = await LocalStorageService.isLoggedIn();
      if (!isLoggedIn) return null;
      return await LocalStorageService.getUser();
    } catch (e) {
      return null;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isUserAuthenticated() async {
    try {
      final isLoggedIn = await LocalStorageService.isLoggedIn();
      final user = await LocalStorageService.getUser();
      return isLoggedIn && user != null;
    } catch (e) {
      return false;
    }
  }

  // Mettre à jour les données utilisateur
  Future<void> updateUserData(UserModel user) async {
    try {
      await LocalStorageService.updateUser(user);
    } catch (e) {
      rethrow;
    }
  }

  // Déconnecter l'utilisateur
  Future<void> clearAuthentication() async {
    try {
      await LocalStorageService.clearUserData();
    } catch (e) {
      rethrow;
    }
  }

  // Synchroniser les données utilisateur avec Firebase
  Future<UserModel?> syncUserWithFirebase(UserModel firebaseUser) async {
    try {
      await saveAuthenticatedUser(firebaseUser);
      return firebaseUser;
    } catch (e) {
      return null;
    }
  }
}
