import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart' as domain;

class UserModel extends domain.User {
  final String? companyName;
  final String? siret;
  final String? activity;
  final String? address;

  UserModel({
    required super.id,
    required super.email,
    required super.userType,
    super.firstName,
    super.lastName,
    super.phone,
    super.profileImageUrl,
    this.companyName,
    this.siret,
    this.activity,
    this.address,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      userType:
          data['type'] == 'professional'
              ? domain.UserType.professional
              : domain.UserType.particular,
      firstName: data['firstName'],
      lastName: data['lastName'],
      phone: data['phone'],
      profileImageUrl: data['profileImage'],
      companyName: data['companyName'],
      siret: data['siret'],
      activity: data['activity'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'type':
          userType == domain.UserType.professional
              ? 'professional'
              : 'particular',
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImage': profileImageUrl,
      'companyName': companyName,
      'siret': siret,
      'activity': activity,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
