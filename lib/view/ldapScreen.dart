import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/apputil.dart';
import '../view_model/auth_view_model.dart';

class LDAPLoginScreen extends StatelessWidget {
  final String tenant;
  final String deviceId;
  late final Function(String token) onLoginPressed;
  final String appName;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LDAPLoginScreen(
      {required this.tenant, required this.deviceId, required this.appName,required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ldap Login'),
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
                  String username = usernameController.text;
                  String password = passwordController.text;
                  if (username.isEmpty ||
                      password.isEmpty ||
                      password.length < 2) {
                    Utils.flushBarErrorMessage(
                        "Please enter a valid username and password", context);
                  } else {
                    hitLdapLoginApi(context, authViewModel, username, password,
                        tenant, deviceId, appName,onLoginPressed);
                  }
                },
                child: Text('Login'),
              ),
              if (authViewModel.loading)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }

  void hitLdapLoginApi(
      BuildContext context,
      AuthViewModel authViewModel,
      String username,
      String password,
      String tenant,
      String deviceId,
      String appName,final Function(String token) onLoginPressed ) {
    Map<String, String> data = {
      "username": username,
      "password": password,
      "tenant": tenant,
      "device": "",
      "app": appName,
    };
    authViewModel.ldapLogin(jsonEncode(data), context,onLoginPressed);
  }
}
