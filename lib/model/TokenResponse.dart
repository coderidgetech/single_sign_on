import 'dart:convert';

class TokenResponse {
  final String? token;
  final String? refreshToken;

  TokenResponse({this.token, this.refreshToken});

  // Factory method to create an instance from a map (deserialization)
  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  // Method to convert an instance to a map (serialization)
  Map<String, dynamic> sucess() {
    return {'status': 'success', 'data': toJson()};
  }

  static Map<String, dynamic> failed(String message) {
    return {'status': 'failed', 'data': message};
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
