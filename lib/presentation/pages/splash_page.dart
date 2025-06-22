import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_persistence_service.dart';
import '../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Attendre un peu pour afficher le splash
    await Future.delayed(const Duration(seconds: 2));

    try {
      print('=== VÉRIFICATION AUTHENTIFICATION ===');

      // Attendre que le contrôleur soit initialisé
      await Future.delayed(const Duration(milliseconds: 500));

      // Essayer de récupérer le contrôleur d'authentification
      AuthController? authController;
      try {
        authController = Get.find<AuthController>();
        print('✅ Contrôleur d\'authentification trouvé');
      } catch (e) {
        print('❌ Contrôleur d\'authentification non trouvé: $e');
      }

      // Vérifier si l'utilisateur est connecté localement
      final isAuthenticated =
          await AuthPersistenceService.instance.isUserAuthenticated();
      final localUser =
          await AuthPersistenceService.instance.getAuthenticatedUser();

      print('isAuthenticated: $isAuthenticated');
      print('localUser: ${localUser?.email}');
      print('controllerUser: ${authController?.currentUser?.email}');

      if (isAuthenticated && localUser != null) {
        // L'utilisateur est connecté localement
        print('✅ Utilisateur connecté détecté: ${localUser.email}');

        // Mettre à jour le contrôleur d'authentification si disponible
        if (authController != null) {
          authController.currentUser = localUser;
          print('✅ Contrôleur d\'authentification mis à jour');
        }

        // Rediriger vers la page d'accueil
        print('🔄 Redirection vers la page des onglets...');
        await Future.delayed(const Duration(milliseconds: 100));
        Get.offAllNamed(Routes.TABS);
      } else {
        // L'utilisateur n'est pas connecté
        print('❌ Aucun utilisateur connecté détecté');
        print('🔄 Redirection vers la page de bienvenue...');
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la vérification de l\'état d\'authentification: $e');
      // En cas d'erreur, rediriger vers la page de bienvenue
      Get.offAllNamed(Routes.WELCOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo/logo.png',
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            // Indicateur de chargement
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
            const SizedBox(height: 20),
            // Texte de chargement
            const Text(
              'Chargement...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
