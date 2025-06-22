import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../domain/entities/user.dart' as domain;
import '../../data/models/user_model.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxString currentSection = 'Accueil'.obs;
  final RxString displayName = 'Utilisateur'.obs;

  final List<Map<String, dynamic>> featuredServices = [
    {
      'name': 'Nettoyage',
      'icon': '🧹',
      'subtitle': 'Maison & Bureau',
    },
    {
      'name': 'Jardinage',
      'icon': '🌿',
      'subtitle': 'Entretien extérieur',
    },
    {
      'name': 'Plomberie',
      'icon': '🔧',
      'subtitle': 'Réparations urgentes',
    },
    {
      'name': 'Électricité',
      'icon': '⚡',
      'subtitle': 'Installation & Dépannage',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    _updateDisplayName();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    final offset = scrollController.offset;

    // Définir les seuils pour chaque section
    if (offset < 200) {
      _updateSection('Accueil');
    } else if (offset < 400) {
      _updateSection('Services populaires');
    } else if (offset < 600) {
      _updateSection('Catégories populaires');
    } else {
      _updateSection('Offres spéciales');
    }
  }

  void _updateSection(String section) {
    if (currentSection.value != section) {
      currentSection.value = section;
    }
  }

  void _updateDisplayName() {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser as UserModel?;

      String name = 'Utilisateur';
      if (currentUser != null) {
        if (currentUser.userType == domain.UserType.professional) {
          // Pour les professionnels, utiliser le nom de l'entreprise
          name = currentUser.companyName ?? 'Professionnel';
        } else {
          // Pour les particuliers, utiliser le prénom ou le nom complet
          if (currentUser.firstName != null &&
              currentUser.firstName!.isNotEmpty) {
            name = currentUser.firstName!;
          } else if (currentUser.lastName != null &&
              currentUser.lastName!.isNotEmpty) {
            name = currentUser.lastName!;
          } else {
            name = 'Utilisateur';
          }
        }
      }

      displayName.value = name;
    } catch (e) {
      print('Erreur lors de la mise à jour du nom: $e');
      displayName.value = 'Utilisateur';
    }
  }

  // Méthode pour rafraîchir les données utilisateur
  void refreshUserData() {
    _updateDisplayName();
  }

  // Méthode pour obtenir l'utilisateur actuel
  UserModel? get currentUser {
    try {
      final authController = Get.find<AuthController>();
      return authController.currentUser as UserModel?;
    } catch (e) {
      return null;
    }
  }

  // Méthode pour obtenir l'initiale du nom
  String get userInitial {
    final name = displayName.value;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  // Méthode pour obtenir l'URL de l'image de profil
  String? get profileImageUrl {
    return currentUser?.profileImageUrl;
  }
}
