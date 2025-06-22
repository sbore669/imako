import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user.dart';
import 'dart:io';

abstract class AuthRepository {
  Future<User> signUp({
    required String email,
    required String password,
    required UserType userType,
    Map<String, dynamic>? additionalData,
  });

  Future<User> signUpProfessional({
    required String email,
    required String password,
    required String companyName,
    String? siret,
    required String activity,
    required String address,
    required String phone,
    File? profileImage,
  });

  Future<User> signIn({required String email, required String password});

  Future<void> signOut();

  User? getCurrentUser();
  Future<User?> getUserData(String uid);
}
