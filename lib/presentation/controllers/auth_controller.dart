import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/services/minio_service.dart';
import '../../data/services/auth_persistence_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final _isLoading = false.obs;
  final _error = RxnString();
  final _currentUser = Rxn<UserModel>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MinioService _minioService = MinioService();
  final AuthPersistenceService _authPersistence =
      AuthPersistenceService.instance;

  // Variables pour la gestion du formulaire
  final profileImage = Rxn<File>();
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  AuthController(this._authRepository);

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  UserModel? get currentUser => _currentUser.value;

  // Setter pour définir l'utilisateur actuel
  set currentUser(UserModel? user) {
    _currentUser.value = user;
  }

  void setProfileImage(File image) {
    profileImage.value = image;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    try {
      // Vérifier d'abord le stockage local
      final localUser = await _authPersistence.getAuthenticatedUser();
      if (localUser != null) {
        _currentUser.value = localUser;
      }

      // Écouter les changements d'état d'authentification Firebase
      _auth.authStateChanges().listen((User? user) async {
        if (user != null) {
          try {
            final userData =
                await _firestore.collection('users').doc(user.uid).get();
            if (userData.exists) {
              final userModel = UserModel.fromFirestore(userData);
              _currentUser.value = userModel;
              // Sauvegarder dans le stockage local
              await _authPersistence.saveAuthenticatedUser(userModel);
            }
          } catch (e) {
            _error.value =
                'Erreur lors de la récupération des données utilisateur';
          }
        } else {
          _currentUser.value = null;
          // Supprimer les données du stockage local
          await _authPersistence.clearAuthentication();
        }
      });
    } catch (e) {
      // rien
    }
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isUserAuthenticated() async {
    return await _authPersistence.isUserAuthenticated();
  }

  // Méthode pour récupérer l'utilisateur connecté
  Future<UserModel?> getAuthenticatedUser() async {
    return await _authPersistence.getAuthenticatedUser();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé par un autre compte';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide';
      case 'operation-not-allowed':
        return 'L\'inscription par email n\'est pas activée';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      default:
        return 'Une erreur est survenue: ${e.message}';
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final userData = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (userData.exists) {
        final userModel = UserModel.fromFirestore(userData);
        _currentUser.value = userModel;
        // Sauvegarder dans le stockage local
        await _authPersistence.saveAuthenticatedUser(userModel);
        Get.offAllNamed(Routes.TABS);
      } else {
        throw Exception('Données utilisateur non trouvées');
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      _error.value = 'Email ou mot de passe incorrect';
      Get.snackbar(
        'Erreur',
        _error.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUpParticular({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    File? profileImage,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? profileImageUrl;
      if (profileImage != null) {
        final fileName = await _minioService.uploadFile(
          profileImage,
          'profile_${userCredential.user!.uid}.jpg',
        );
        profileImageUrl = _minioService.getFileUrl(fileName);
      }

      final userData = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'type': 'particular',
        'profileImage': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final userModel = UserModel.fromFirestore(userDoc);
      _currentUser.value = userModel;
      // Sauvegarder dans le stockage local
      await _authPersistence.saveAuthenticatedUser(userModel);
      Get.offAllNamed(Routes.TABS);
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      _error.value = 'Une erreur est survenue lors de l\'inscription';
      Get.snackbar(
        'Erreur',
        _error.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUpProfessional({
    required String email,
    required String password,
    required String companyName,
    String? siret,
    required String activity,
    required String address,
    required String phone,
    File? profileImage,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? profileImageUrl;
      if (profileImage != null) {
        final fileName = await _minioService.uploadFile(
          profileImage,
          'profile_${userCredential.user!.uid}.jpg',
        );
        profileImageUrl = _minioService.getFileUrl(fileName);
      }

      final userData = {
        'email': email,
        'type': 'professional',
        'companyName': companyName,
        'siret': siret,
        'activity': activity,
        'address': address,
        'phone': phone,
        'profileImage': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final userModel = UserModel.fromFirestore(userDoc);
      _currentUser.value = userModel;
      // Sauvegarder dans le stockage local
      await _authPersistence.saveAuthenticatedUser(userModel);
      Get.offAllNamed(Routes.TABS);
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      _error.value = 'Une erreur est survenue lors de l\'inscription';
      Get.snackbar(
        'Erreur',
        _error.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _auth.signOut();
      _currentUser.value = null;
      profileImage.value = null;
      // Supprimer les données du stockage local
      await _authPersistence.clearAuthentication();

      Get.offAllNamed('/');
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      _error.value = 'Une erreur est survenue lors de la déconnexion';
      Get.snackbar(
        'Erreur',
        _error.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
