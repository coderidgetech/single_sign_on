class LoginPayload {
  final String tenant;
  final String username;
  final String password;

  LoginPayload({
    required this.tenant,
    required this.username,
    required this.password,
  });

  // Optionally, you can add methods for converting to/from JSON if needed
  factory LoginPayload.fromJson(Map<String, dynamic> json) {
    return LoginPayload(
      tenant: json['tenant'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant': tenant,
      'username': username,
      'password': password,
    };
  }
}
