import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../data/services/auth_persistence_service.dart';
import '../../routes/app_pages.dart';

class RootRedirectPage extends StatelessWidget {
  const RootRedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    Future.microtask(() async {
      try {
        // Vérifier d'abord le stockage local
        final isAuthenticated =
            await AuthPersistenceService.instance.isUserAuthenticated();
        final localUser =
            await AuthPersistenceService.instance.getAuthenticatedUser();

        if (isAuthenticated && localUser != null) {
          // Mettre à jour le contrôleur avec les données locales
          authController.currentUser = localUser;
          Get.offAllNamed(Routes.TABS);
        } else if (authController.currentUser != null) {
          // L'utilisateur est connecté via Firebase
          Get.offAllNamed(Routes.TABS);
        } else {
          // Aucun utilisateur connecté
          Get.offAllNamed(Routes.WELCOME);
        }
      } catch (e) {
        print(
            'Erreur lors de la vérification de l\'état d\'authentification: $e');
        Get.offAllNamed(Routes.WELCOME);
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
