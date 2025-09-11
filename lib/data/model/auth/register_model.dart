class RegisterModel {
  final String fullName;
  final String password;
  final String email;

  RegisterModel({required this.fullName, required this.password, required this.email,});

  Map<String, dynamic> toJson() {
    return {"fullName": fullName, "password": password, "email": email};
  }
}
