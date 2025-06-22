enum UserType { particular, professional }

class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImageUrl;
  final UserType userType;
  final Map<String, dynamic> additionalData;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImageUrl,
    required this.userType,
    this.additionalData = const {},
  });
}
