class LoginModel {
  final String login;
  final String password;


  LoginModel({required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {"login": login, "password": password};
  }
}
