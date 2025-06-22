import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imako_app/domain/repositories/auth_repository.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/minio_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        firebase_auth.FirebaseAuth.instance,
        FirebaseFirestore.instance,
        MinioService(),
      ),
    );

    Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));
  }
}
