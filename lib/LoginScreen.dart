import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(String token) onLoginPressed;
  final VoidCallback onSignUpPressed;

  LoginScreen({
    required this.onLoginPressed,
    required this.onSignUpPressed,
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
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Retrieve username and password from text fields
                  String token = ''; // Retrieve username from TextFormField
                  String password = ''; // Retrieve password from TextFormField

                  // Call the onLoginPressed callback with username and password
                  onLoginPressed(token);
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
