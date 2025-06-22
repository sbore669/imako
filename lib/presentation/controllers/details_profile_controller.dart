import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';
import '../../data/models/realisation_model.dart';
import '../pages/fullscreen_media_viewer.dart';

class DetailsProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables observables
  final Rx<UserModel?> professional = Rx<UserModel?>(null);
  final RxList<RealisationModel> realisations = <RealisationModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingRealisations = true.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  UserModel? get currentProfessional => professional.value;
  List<RealisationModel> get currentRealisations => realisations;
  bool get isDataLoading => isLoading.value;
  bool get isRealisationsLoading => isLoadingRealisations.value;
  String get currentError => errorMessage.value;

  @override
  void onInit() {
    super.onInit();
  }

  /// Charge les données du professionnel
  Future<void> loadProfessionalData(String professionalId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final doc =
          await _firestore.collection('users').doc(professionalId).get();

      if (doc.exists) {
        professional.value = UserModel.fromFirestore(doc);
      } else {
        errorMessage.value = 'Professionnel non trouvé';
      }
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement du professionnel';
    } finally {
      isLoading.value = false;
    }
  }

  /// Charge les réalisations du professionnel
  Future<void> loadRealisations(String professionalId) async {
    try {
      isLoadingRealisations.value = true;
      errorMessage.value = '';

      // Requête simplifiée sans orderBy pour éviter le problème d'index
      final querySnapshot = await _firestore
          .collection('realisations')
          .where('professionalId', isEqualTo: professionalId)
          .limit(10)
          .get();

      final List<RealisationModel> loadedRealisations = [];

      for (var doc in querySnapshot.docs) {
        try {
          final realisation = RealisationModel.fromFirestore(doc);
          loadedRealisations.add(realisation);
        } catch (e) {
          // Gestion silencieuse des erreurs de parsing
        }
      }

      // Trier les réalisations par date de création (plus récentes en premier)
      loadedRealisations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      realisations.assignAll(loadedRealisations);
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des réalisations';
    } finally {
      isLoadingRealisations.value = false;
    }
  }

  /// Initialise les données pour un professionnel
  Future<void> initializeData(String professionalId) async {
    await Future.wait([
      loadProfessionalData(professionalId),
      loadRealisations(professionalId),
    ]);
  }

  /// Test de la structure des données
  Future<void> testDataStructure() async {
    // Méthode supprimée - plus nécessaire en production
  }

  /// Contacte le professionnel
  void contactProfessional() {
    final name = professional.value?.companyName ?? 'le professionnel';
    Get.snackbar(
      'Contact',
      'Ouverture du chat avec $name',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Partage le profil du professionnel
  void shareProfile() {
    Get.snackbar(
      'Partage',
      'Fonctionnalité de partage',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
    );
  }

  /// Ouvre une réalisation en plein écran
  void openRealisation(List<String> mediaUrls, int initialIndex) {
    Get.to(() => FullscreenMediaViewer(
          mediaUrls: mediaUrls,
          initialIndex: initialIndex,
        ));
  }

  @override
  void onClose() {
    // Nettoyage des ressources si nécessaire
    super.onClose();
  }
}
