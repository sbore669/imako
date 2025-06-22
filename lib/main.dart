import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imako_app/firebase_options.dart';
import 'routes/app_pages.dart';
import 'data/services/auth_persistence_service.dart';
import 'presentation/controllers/auth_controller.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/services/minio_service.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurer la langue française pour timeago
  timeago.setLocaleMessages('fr', timeago.FrMessages());

  // Initialisation du AuthController pour GetX avec AuthRepositoryImpl
  final authRepository = AuthRepositoryImpl(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    MinioService(),
  );
  Get.put(AuthController(authRepository));

  // Vérifier l'état d'authentification avant de démarrer l'app
  final isAuthenticated =
      await AuthPersistenceService.instance.isUserAuthenticated();
  final initialRoute = isAuthenticated ? Routes.TABS : Routes.WELCOME;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Imako',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
