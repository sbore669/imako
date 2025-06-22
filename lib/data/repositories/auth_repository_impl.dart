import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imako_app/domain/entities/user.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'package:imako_app/data/services/minio_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final MinioService _minioService;

  AuthRepositoryImpl(this._auth, this._firestore, this._minioService);

  Future<void> _rollbackUserCreation(firebase_auth.User user) async {
    try {
      await user.delete();
      print('Utilisateur supprimé après erreur');
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur: $e');
    }
  }

  Future<void> _rollbackImageUpload(String imagePath) async {
    try {
      await _minioService.deleteFile(imagePath);
      print('Image supprimée après erreur');
    } catch (e) {
      print('Erreur lors de la suppression de l\'image: $e');
    }
  }

  @override
  Future<domain.User> signUp({
    required String email,
    required String password,
    required domain.UserType userType,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Échec de la création de l\'utilisateur');
      }

      final userData = <String, Object>{
        'email': email,
        'userType': userType.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (additionalData != null) {
        userData.addAll(
          additionalData.map((key, value) => MapEntry(key, value as Object)),
        );
      }

      await _firestore.collection('users').doc(user.uid).set(userData);

      return UserModel(
        id: user.uid,
        email: email,
        userType: userType,
        firstName:
            additionalData != null && additionalData['firstName'] != null
                ? additionalData['firstName'] as String
                : '',
        lastName:
            additionalData != null && additionalData['lastName'] != null
                ? additionalData['lastName'] as String
                : '',
        phone:
            additionalData != null && additionalData['phone'] != null
                ? additionalData['phone'] as String
                : '',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<domain.User> signUpProfessional({
    required String email,
    required String password,
    required String companyName,
    String? siret,
    required String activity,
    required String address,
    required String phone,
    File? profileImage,
  }) async {
    print('Début de l\'inscription professionnelle');
    String? profileImageUrl;
    firebase_auth.User? createdUser;

    try {
      // 1. Créer l'utilisateur dans Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createdUser = userCredential.user;

      if (createdUser == null) {
        throw Exception('Échec de la création de l\'utilisateur');
      }
      print('Utilisateur créé avec succès dans Firebase Auth');

      // 2. Upload de l'image de profil si elle existe
      if (profileImage != null) {
        try {
          profileImageUrl = await _minioService.uploadFile(
            profileImage,
            'profile_${createdUser.uid}.jpg',
          );
          print('Image de profil uploadée avec succès vers MinIO');
        } catch (e) {
          print('Erreur lors de l\'upload de l\'image vers MinIO: $e');
          // On continue même si l'upload échoue
        }
      }

      // 3. Créer le document utilisateur dans Firestore
      await _firestore.runTransaction((transaction) async {
        final userDoc = _firestore.collection('users').doc(createdUser!.uid);

        final userData = <String, Object>{
          'email': email,
          'userType': 'professional',
          'companyName': companyName,
          'activity': activity,
          'address': address,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (siret != null) {
          userData['siret'] = siret;
        }

        if (profileImageUrl != null) {
          userData['profileImageUrl'] = profileImageUrl;
        }

        transaction.set(userDoc, userData);
      });

      // 4. Mettre à jour la photo URL dans Firebase Auth si l'upload a réussi
      if (profileImageUrl != null) {
        await createdUser.updatePhotoURL(profileImageUrl);
      }

      return UserModel(
        id: createdUser.uid,
        email: email,
        userType: domain.UserType.professional,
        companyName: companyName,
        activity: activity,
        address: address,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      // Nettoyage en cas d'erreur
      if (createdUser != null) {
        try {
          await createdUser.delete();
          print('Utilisateur supprimé après erreur');
        } catch (deleteError) {
          print(
            'Erreur lors de la suppression de l\'utilisateur: $deleteError',
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<domain.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Échec de la connexion');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception('Données utilisateur non trouvées');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<domain.User?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  @override
  domain.User? getCurrentUser() {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      userType:
          domain
              .UserType
              .particular, // Type par défaut, sera mis à jour lors de la récupération des données
    );
  }
}
