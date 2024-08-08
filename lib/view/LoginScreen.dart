import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/res/Constants.dart';
import 'package:single_sign_on/utils/apputil.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/routes/routes_name.dart';

class LoginScreen extends StatelessWidget {
  late final Function(String token) onLoginPressed;
  late final String baseUrl;
  late final String tenant;
  late final String deviceID;
  late final String appName;
  late final List<String> loginTypes;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen(
      {required this.onLoginPressed,
      required this.baseUrl,
      required this.tenant,
      required this.deviceID,
      required this.appName,
      required this.loginTypes,
      required bool havingManagedConfig});

  @override
  Widget build(BuildContext context) {
    // saveInCache(baseUrl, tenant, deviceID, appName);
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
                  ElevatedButton(
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      if (username.isEmpty ||
                          password.isEmpty ||
                          password.length < 2) {
                        Utils.flushBarErrorMessage(
                            "Please enter valid username or password", context);
                      } else {
                        hitLoginApi(context, authViewModel, tenant, username,
                            password, onLoginPressed, baseUrl);
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                    visible: loginTypes.contains('google'),
                    // Show for Google login type
                    child: ElevatedButton(
                      onPressed: () async {
                        handlingGoogleAuthAndMicrosoft(
                            context, authViewModel, onLoginPressed, 'google',baseUrl);
                      },
                      child: Text('Sign in with Google'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                    visible: loginTypes.contains('microsoft'),
                    child: ElevatedButton(
                      onPressed: () {
                        handlingGoogleAuthAndMicrosoft(context, authViewModel,
                            onLoginPressed, 'microsoft',baseUrl);
                      },
                      child: Text('Sign in with Microsoft'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                    visible: loginTypes.contains('ldap'),
                    // Show for LDAP login type
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.ldap,
                            arguments: {
                              'tenant': tenant,
                              'deviceId': deviceID,
                              'appName': appName,
                              'call_back': onLoginPressed,
                              'baseUrl': baseUrl
                            });
                      },
                      child: Text('Sign in with LDAP'),
                    ),
                  ),
                  if (authViewModel.loading)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void handlingGoogleAuthAndMicrosoft(
      BuildContext context,
      AuthViewModel authViewModel,
      Function(String token) onLoginPressed,
      String loginTypeee,String baseUrl) {
    Map<String, String> queryParams = {
      'tenant': tenant,
      'mode': loginTypeee,
      'device': deviceID,
      'app': appName,
    };
    authViewModel.googlesigin(queryParams, context,baseUrl).then((authUrl) {
      Navigator.pushNamed(context, RoutesName.web_view, arguments: {
        'authUrl': authUrl,
        'call_back': onLoginPressed,
        'authViewModel': authViewModel,
        'baseUrl':baseUrl
      });
    });
  }

  void saveInCache(
      String baseUrl, String tenant, String deviceID, String appName) async {
    // await SharedPrefs.saveString(Constants.baseUrl, baseUrl);
    // await SharedPrefs.saveString(Constants.tenant, tenant);
    // await SharedPrefs.saveString(Constants.deviceID, deviceID);
    // await SharedPrefs.saveString(Constants.appName, appName);
  }
}

void hitLoginApi(
    BuildContext context,
    AuthViewModel authViewModel,
    String tenant,
    String username,
    String password,
    Function(String token) onLoginPressed,
    String baseUrl) {
  Map data = {"tenant": tenant, "username": username, "password": password};
  authViewModel.loginApi(jsonEncode(data), context, onLoginPressed,baseUrl);
}

class WebViewScreen extends StatefulWidget {
  final String authUrl;
  final String baseUrl;

  final Function(String token) onLoginPressed;

  // WebViewScreen({required this.authUrl, required this.onLoginPressed});
  WebViewScreen({
    required this.authUrl,
    required this.onLoginPressed,
    required this.baseUrl,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

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
            final String? code = uri.queryParameters['code'];
            final String? state = uri.queryParameters['state'];

            if (code != null && state != null) {
              // TODO : Hit the api with code and get the token
              Map<String, String> data = {
                'code': code,
                'state': state,
              };
              print("object");
              String token = await authViewModel.validateCode(
                  jsonEncode(data), widget.onLoginPressed,widget.baseUrl);
              if (token != null) {
                widget.onLoginPressed(token);
                // Navigator.pop(context);
              } else {
                Utils.toastMessage("Error in geting token");
              }
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
