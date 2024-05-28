import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/res/Constants.dart';
import 'package:single_sign_on/utils/apputil.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatelessWidget {
  late final Function(String token) onLoginPressed;
  late final String baseUrl;
  late final String loginType;
  late final String tenant;
  late final String deviceID;
  late final String appName;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen(
      {required this.onLoginPressed,
      required this.baseUrl,
      required this.loginType,
      required this.tenant,
      required this.deviceID,
      required this.appName});

  @override
  Widget build(BuildContext context) {
    saveInCache(baseUrl, tenant, deviceID, appName);
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authProvider, _) {
          return Center(
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
                  Visibility(
                    visible: loginType == 'google',
                    // Show for Google login type
                    child: ElevatedButton(
                      onPressed: () async {
                        handlingGoogleAuthAndMicrosoft(context, authViewModel);
                        onLoginPressed('google_token');
                      },
                      child: Text('Sign in with Google'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                    visible: loginType == 'microsoft',
                    child: ElevatedButton(
                      onPressed: () {
                        Utils.snackBar("Microdof", context);
                        handlingGoogleAuthAndMicrosoft(context, authViewModel);
                        onLoginPressed('microsoft_token');
                      },
                      child: Text('Sign in with Microsoft'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                    visible: loginType == 'ldap', // Show for LDAP login type
                    child: ElevatedButton(
                      onPressed: () {
                        // LDAP sign-in logic
                        // Pass necessary parameters to onLoginPressed
                        onLoginPressed('ldap_token');
                      },
                      child: Text('Sign in with LDAP'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      if (username.isEmpty ||password.isEmpty ||password.length < 2) {
                        Utils.flushBarErrorMessage("Please enter valid username or password", context);
                      } else {
                        hitLoginApi(context, authViewModel, tenant, username, password,onLoginPressed);
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void handlingGoogleAuthAndMicrosoft(
      BuildContext context, AuthViewModel authViewModel) {
    Map<String, String> queryParams = {
      'tenant': tenant,
      'mode': loginType,
      'device': deviceID,
      'app': appName,
    };
    authViewModel.googlesigin(queryParams, context);
  }

  void saveInCache(
      String baseUrl, String tenant, String deviceID, String appName) async {
    await SharedPrefs.saveString(Constants.baseUrl, baseUrl);
    await SharedPrefs.saveString(Constants.tenant, tenant);
    await SharedPrefs.saveString(Constants.deviceID, deviceID);
    await SharedPrefs.saveString(Constants.appName, appName);
  }

}
void hitLoginApi(BuildContext context, AuthViewModel authViewModel,
    String tenant, String username, String password, Function(String token) onLoginPressed) {
  Map data = {"tenant": tenant, "username": "emmteam", "password": "Welcome@1"};

  authViewModel.loginApi(jsonEncode(data), context,onLoginPressed);
}

class WebViewScreen extends StatefulWidget {
  final String authUrl;

  // final Function(String token) onLoginPressed;

  // WebViewScreen({required this.authUrl, required this.onLoginPressed});
  WebViewScreen({required this.authUrl});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: WebView(
        initialUrl: widget.authUrl,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: "Agent",
        onWebViewCreated: (WebViewController controller) {
          _webViewController = controller;
        },
        navigationDelegate: (NavigationRequest request) async {
          // Handle URL navigation
          if (request.url.startsWith('https://portal.emmdev.tectoro')) {
            final Uri uri = Uri.parse(request.url);
            final String? token = uri.queryParameters['code'];
            if (token != null) {
              // Close the WebView
              Navigator.pop(context);
              // Call the onLoginPressed function with the token
              // widget.onLoginPressed(token);
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
