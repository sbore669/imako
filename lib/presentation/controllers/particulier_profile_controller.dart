import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../data/models/user_model.dart';

class ParticulierProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Variables observables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Contrôleurs de texte (pour l'affichage uniquement)
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Getters
  UserModel? get user => currentUser.value;
  bool get isDataLoading => isLoading.value;
  String get currentError => errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Charge les données de l'utilisateur connecté
  void loadUserData() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = _authController.currentUser as UserModel?;
      currentUser.value = user;

      if (user != null) {
        // Initialiser les contrôleurs avec les données actuelles
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        emailController.text = user.email ?? '';
        phoneController.text = user.phone ?? '';
      } else {
        errorMessage.value = 'Aucun utilisateur connecté';
      }
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des données';
    } finally {
      isLoading.value = false;
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> signOut() async {
    try {
      await _authController.signOut();
      Get.offAllNamed('/login'); // Redirection vers la page de connexion
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la déconnexion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Retourne à la page précédente
  void goBack() {
    Get.back();
  }

  /// Obtient l'initiale du prénom
  String getInitial() {
    final user = currentUser.value;
    if (user?.firstName?.isNotEmpty == true) {
      return user!.firstName![0].toUpperCase();
    }
    return 'U';
  }

  /// Obtient le nom complet
  String getFullName() {
    final user = currentUser.value;
    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    return 'Utilisateur';
  }

  /// Vérifie si l'utilisateur a une photo de profil
  bool hasProfileImage() {
    final user = currentUser.value;
    return user?.profileImageUrl != null && user!.profileImageUrl!.isNotEmpty;
  }

  /// Obtient l'URL de la photo de profil
  String? getProfileImageUrl() {
    return currentUser.value?.profileImageUrl;
  }

  /// Obtient l'email
  String? getEmail() {
    return currentUser.value?.email;
  }

  /// Obtient le téléphone
  String? getPhone() {
    return currentUser.value?.phone;
  }

  /// Vérifie si une information est disponible
  bool hasInfo(String? value) {
    return value != null && value.isNotEmpty;
  }
}
