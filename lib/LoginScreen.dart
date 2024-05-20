import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(String token, String baseUrl, String loginType, String tenant) onLoginPressed;
  final VoidCallback onSignUpPressed;
  final String baseUrl;
  final String loginType;
  final String tenant;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({
    required this.onLoginPressed,
    required this.onSignUpPressed,
    required this.baseUrl,
    required this.loginType,
    required this.tenant
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Retrieve username and password from text fields
                  String username = usernameController.text;
                  String password = passwordController.text;

                  // Combine username and password or use only one as token
                  String token = '$username:$password'; // Or any logic you need

                  // Call the onLoginPressed callback with the token, baseUrl, and loginType
                  onLoginPressed(token, baseUrl, loginType,tenant);
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: onSignUpPressed,
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
