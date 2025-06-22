import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_persistence_service.dart';
import '../../routes/app_pages.dart';

class SplashPageV2 extends StatefulWidget {
  const SplashPageV2({Key? key}) : super(key: key);

  @override
  State<SplashPageV2> createState() => _SplashPageV2State();
}

class _SplashPageV2State extends State<SplashPageV2> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Attendre un peu pour afficher le splash
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Vérifier directement si l'utilisateur est connecté
      final isAuthenticated =
          await AuthPersistenceService.instance.isUserAuthenticated();
      final localUser =
          await AuthPersistenceService.instance.getAuthenticatedUser();

      if (isAuthenticated && localUser != null) {
        // Rediriger vers TABS
        Get.offAllNamed(Routes.TABS);
      } else {
        // Rediriger vers WELCOME
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
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
              'Vérification de l\'authentification...',
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
