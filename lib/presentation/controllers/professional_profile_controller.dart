import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../data/models/user_model.dart';

class ProfessionalProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Variables observables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  UserModel? get user => currentUser.value;
  bool get isDataLoading => isLoading.value;
  String get currentError => errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Charge les données de l'utilisateur connecté
  void loadUserData() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = _authController.currentUser as UserModel?;
      currentUser.value = user;

      if (user == null) {
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

  /// Modifie le profil
  void editProfile() {
    Get.snackbar(
      'Modification',
      'Fonctionnalité de modification en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Ouvre les paramètres
  void openSettings() {
    Get.snackbar(
      'Paramètres',
      'Fonctionnalité en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF64748B),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Ouvre l'aide et support
  void openHelpSupport() {
    Get.snackbar(
      'Support',
      'Fonctionnalité en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Retourne à la page précédente
  void goBack() {
    Get.back();
  }

  /// Obtient l'initiale du nom d'entreprise ou du prénom
  String getInitial() {
    final user = currentUser.value;
    if (user?.companyName?.isNotEmpty == true) {
      return user!.companyName![0].toUpperCase();
    } else if (user?.firstName?.isNotEmpty == true) {
      return user!.firstName![0].toUpperCase();
    }
    return 'P';
  }

  /// Obtient le nom d'affichage
  String getDisplayName() {
    final user = currentUser.value;
    return user?.companyName ?? user?.firstName ?? 'Nom de l\'entreprise';
  }

  /// Obtient l'activité
  String getActivity() {
    return currentUser.value?.activity ?? 'Activité non spécifiée';
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

  /// Obtient l'adresse
  String? getAddress() {
    return currentUser.value?.address;
  }

  /// Obtient le SIRET
  String? getSiret() {
    return currentUser.value?.siret;
  }

  /// Vérifie si une information est disponible
  bool hasInfo(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// Obtient les statistiques de l'utilisateur
  Map<String, dynamic> getStats() {
    // TODO: Récupérer les vraies statistiques depuis Firestore
    return {
      'realisations': '12',
      'avis': '4.8',
      'clients': '150+',
      'experience': '2 ans',
    };
  }

  @override
  void onClose() {
    // Nettoyage des ressources si nécessaire
    super.onClose();
  }
}
