import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/apputil.dart';
import '../view_model/auth_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
class LDAPLoginScreen extends StatelessWidget {
  final String tenant;
  final String deviceId;
  final String baseUrl;
  late final Function(String token) onLoginPressed;
  final String appName;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LDAPLoginScreen(
      {required this.tenant,
        required this.deviceId,
        required this.appName,
        required this.onLoginPressed,
        required this.baseUrl});
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ldap Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backg.png'),
            fit: BoxFit.fill, // Adjust as needed
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/tectoro.svg'),
                      SizedBox(height: 10),
                      Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26,color: Colors.white),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
                    color: Colors.white,
                    child: Padding(padding: EdgeInsets.all(10),
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
                                    tenant, deviceId, appName, onLoginPressed, baseUrl);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff00BFC0), // Background color
                              foregroundColor: Colors.white, // Text color
                              elevation: 2, // Elevation of the button
                              minimumSize: Size(double.maxFinite, 50), // Width and height of the button
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                            ),
                            child: Text('Login'),
                          ),
                        ],
                      ),),
                  ),
                ),
                SizedBox(height: 40,),
                if (authViewModel.loading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
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
      String appName,
      final Function(String token) onLoginPressed,
      String baseUrl) {
    Map<String, String> data = {
      "username": username,
      "password": password,
      "tenant": tenant,
      "device": "",
      "app": appName,
    };
    authViewModel.ldapLogin(jsonEncode(data), context, onLoginPressed,baseUrl);
  }
}