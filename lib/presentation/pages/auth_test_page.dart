import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../data/services/auth_persistence_service.dart';
import '../../routes/app_pages.dart';

class AuthTestPage extends StatefulWidget {
  const AuthTestPage({Key? key}) : super(key: key);

  @override
  State<AuthTestPage> createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final AuthController _authController = Get.find<AuthController>();
  String _authStatus = 'Vérification...';
  String _userInfo = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Vérifier l'état d'authentification
      final isAuthenticated =
          await AuthPersistenceService.instance.isUserAuthenticated();
      final localUser =
          await AuthPersistenceService.instance.getAuthenticatedUser();
      final controllerUser = _authController.currentUser;

      setState(() {
        if (isAuthenticated && localUser != null) {
          _authStatus = '✅ Utilisateur connecté';
          _userInfo = '''
Email: ${localUser.email}
Type: ${localUser.userType}
Nom: ${localUser.firstName ?? 'N/A'} ${localUser.lastName ?? 'N/A'}
Téléphone: ${localUser.phone ?? 'N/A'}
ID: ${localUser.id}
          ''';
        } else {
          _authStatus = '❌ Aucun utilisateur connecté';
          _userInfo = 'Aucune donnée utilisateur trouvée';
        }
      });

      print('État d\'authentification: $isAuthenticated');
      print('Utilisateur local: ${localUser?.email}');
      print('Utilisateur contrôleur: ${controllerUser?.email}');
    } catch (e) {
      setState(() {
        _authStatus = '❌ Erreur: $e';
        _userInfo = 'Erreur lors de la vérification';
      });
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await AuthPersistenceService.instance.clearAuthentication();
      await _checkAuthStatus();
      Get.snackbar(
        'Succès',
        'Données d\'authentification supprimées',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la suppression: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test d\'Authentification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkAuthStatus,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'État d\'Authentification',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _authStatus,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations Utilisateur',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userInfo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkAuthStatus,
                    child: const Text('Actualiser'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAuthData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Supprimer Données'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(Routes.TABS),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aller à Tabs'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(Routes.WELCOME),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aller à Welcome'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
