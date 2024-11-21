class LoginEntity {
  final String email;
  final String password;

  LoginEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterEntity {
  final String email;
  final String password;
  final String name;

  RegisterEntity({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory RegisterEntity.fromJson(Map<String, dynamic> json) {
    return RegisterEntity(
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }
}