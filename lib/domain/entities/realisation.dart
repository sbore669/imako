import 'package:cloud_firestore/cloud_firestore.dart';

class Realisation {
  final String id;
  final String professionalId;
  final String professionalName;
  final String? professionalProfileImageUrl;
  final String description;
  final List<String> mediaUrls;
  final String title;
  final Timestamp createdAt;
  final int likes;
  final int comments;
  final String? whatsappNumber;

  Realisation({
    required this.id,
    required this.professionalId,
    required this.professionalName,
    this.professionalProfileImageUrl,
    required this.description,
    required this.mediaUrls,
    required this.title,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.whatsappNumber,
  });
}
