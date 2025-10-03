class ProfileUpdateModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;

  const ProfileUpdateModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
  });

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
    };
  }

  ProfileUpdateModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? birthDate,
    String? gender,
  }) {
    return ProfileUpdateModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }
}