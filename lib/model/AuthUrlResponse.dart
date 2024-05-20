class AuthUrlResponse {
  final String data;
  final String status;

  AuthUrlResponse({required this.data, required this.status});

  factory AuthUrlResponse.fromJson(Map<String, dynamic> json) {
    return AuthUrlResponse(
      data: json['data'],
      status: json['status'],
    );
  }
}
