import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imako_app/data/models/realisation_model.dart';
import 'package:imako_app/data/models/user_model.dart';
import 'package:imako_app/data/services/minio_service.dart';
import 'package:imako_app/domain/repositories/realisation_repository.dart';

class RealisationRepositoryImpl implements RealisationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MinioService _minioService = MinioService();

  @override
  Future<void> createRealisation({
    required String description,
    required String title,
    required List<XFile> mediaFiles,
    String? whatsappNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    // Récupérer les données du professionnel
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      throw Exception("Données du professionnel introuvables.");
    }
    final userModel = UserModel.fromFirestore(userDoc);

    // Uploader les médias sur Minio et récupérer les URLs
    final List<String> mediaUrls = [];
    for (var file in mediaFiles) {
      final fileName =
          'realisations/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final fileUrl = await _minioService.uploadFile(File(file.path), fileName);
      mediaUrls.add(fileUrl);
    }

    // Créer le modèle de réalisation
    final newRealisation = RealisationModel(
      id: '', // Firestore génèrera l'ID
      professionalId: user.uid,
      professionalName: userModel.companyName ?? 'Pro Anonyme',
      professionalProfileImageUrl: userModel.profileImageUrl,
      description: description,
      title: title,
      mediaUrls: mediaUrls,
      createdAt: Timestamp.now(),
      likes: 0,
      comments: 0,
      whatsappNumber: whatsappNumber,
    );

    // Ajouter la nouvelle réalisation à Firestore
    await _firestore
        .collection('realisations')
        .add(newRealisation.toFirestore());
  }

  @override
  Future<List<RealisationModel>> getRealisations() async {
    final snapshot = await _firestore
        .collection('realisations')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RealisationModel.fromFirestore(doc))
        .toList();
  }
}
