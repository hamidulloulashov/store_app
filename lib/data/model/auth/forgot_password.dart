class RegisterModel {
  final String email;

  RegisterModel({ required this.email,});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
