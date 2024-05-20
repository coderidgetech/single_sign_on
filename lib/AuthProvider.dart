import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String username, String password, String baseUrl, String loginType) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: '{"username": "$username", "password": "$password", "loginType": "$loginType"}',
    );

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      // Handle successful login
      print('Login successful: ${response.body}');
    } else {
      // Handle login failure
      print('Login failed: ${response.statusCode}');
    }
  }
  Future<String> fetchAuthUrl(String baseUrl, String tenant, String loginType, String deviceID, String appName) async {
    // Construct query parameters
    Map<String, String> queryParams = {
      'tenant': tenant,
      'mode': loginType,
      'device': deviceID,
      'app': appName,
    };

    // Append query parameters to the URL
    Uri uriWithQuery = Uri.parse('$baseUrl/login').replace(queryParameters: queryParams);

    try {
      _isLoading = true;
      // Make the API request
      final response = await http.get(
        uriWithQuery,
        headers: {'Content-Type': 'application/json'},
      );
      _isLoading = false;
      if (response.statusCode == 200) {
        // Handle successful response
        return response.body; // Return the auth URL
      } else {
        _isLoading = false;
        // Handle request failure
        throw Exception('Failed to fetch auth URL: ${response.statusCode}');
      }
    } catch (error) {
      _isLoading = false;
      // Handle network errors or other exceptions
      throw Exception('Error fetching auth URL: $error');
    }
  }
}
