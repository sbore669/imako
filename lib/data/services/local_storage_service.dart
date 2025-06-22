import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart' as domain;

class LocalStorageService {
  static const String _userKey = 'current_user';
  static const String _authTokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  // Sauvegarder les données utilisateur
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'id': user.id,
      'email': user.email,
      'userType': user.userType.toString().split('.').last,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phone': user.phone,
      'profileImageUrl': user.profileImageUrl,
      'companyName': user.companyName,
      'siret': user.siret,
      'activity': user.activity,
      'address': user.address,
    };
    await prefs.setString(_userKey, jsonEncode(userData));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Récupérer les données utilisateur
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        final userData = jsonDecode(userString) as Map<String, dynamic>;
        return UserModel(
          id: userData['id'] ?? '',
          email: userData['email'] ?? '',
          userType: _parseUserType(userData['userType']),
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          phone: userData['phone'],
          profileImageUrl: userData['profileImageUrl'],
          companyName: userData['companyName'],
          siret: userData['siret'],
          activity: userData['activity'],
          address: userData['address'],
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Sauvegarder le token d'authentification
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Récupérer le token d'authentification
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Supprimer toutes les données utilisateur
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_authTokenKey);
    await prefs.remove(_isLoggedInKey);
  }

  // Mettre à jour les données utilisateur
  static Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  // Parser le type d'utilisateur
  static domain.UserType _parseUserType(String? userType) {
    switch (userType) {
      case 'professional':
        return domain.UserType.professional;
      case 'particular':
      default:
        return domain.UserType.particular;
    }
  }
}
