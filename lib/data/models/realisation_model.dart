import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/realisation.dart';

class RealisationModel extends Realisation {
  RealisationModel({
    required super.id,
    required super.professionalId,
    required super.professionalName,
    super.professionalProfileImageUrl,
    required super.description,
    required super.mediaUrls,
    required super.title,
    required super.createdAt,
    super.likes,
    super.comments,
    super.whatsappNumber,
  });

  factory RealisationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RealisationModel(
      id: doc.id,
      professionalId: data['professionalId'] ?? '',
      professionalName: data['professionalName'] ?? 'Pro Anonyme',
      professionalProfileImageUrl: data['professionalProfileImageUrl'],
      description: data['description'] ?? '',
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      title: data['title'] ?? 'Sans titre',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      whatsappNumber: data['whatsappNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalProfileImageUrl': professionalProfileImageUrl,
      'description': description,
      'mediaUrls': mediaUrls,
      'title': title,
      'createdAt': createdAt,
      'likes': likes,
      'comments': comments,
      'whatsappNumber': whatsappNumber,
    };
  }
}
