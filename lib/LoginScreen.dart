  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:single_sign_on/AuthProvider.dart';
import 'package:single_sign_on/model/AuthUrlResponse.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:webview_flutter/webview_flutter.dart';

  import 'Config.dart';

  class LoginScreen extends StatelessWidget {
    final Function(String token) onLoginPressed;
    final VoidCallback onSignUpPressed;
    final String baseUrl;
    final String loginType;
    final String tenant;
    final String deviceID;
    final String appName;

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    LoginScreen(
        {required this.onLoginPressed,
        required this.onSignUpPressed,
        required this.baseUrl,
        required this.loginType,
        required this.tenant,
        required this.deviceID,
        required this.appName});

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Consumer<AuthProvider>(
          builder: (context,authProvider,_){
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
                      visible: loginType == 'google', // Show for Google login type
                      child: ElevatedButton(
                        onPressed: () async {
                          // Google sign-in logic
                          // Pass necessary parameters to onLoginPressed
                          AuthUrlResponse authUrl = await Provider.of<AuthProvider>(context,listen: false).fetchAuthUrl( baseUrl, tenant, loginType, deviceID, appName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(authUrl: authUrl.data,onLoginPressed: onLoginPressed,),
                            ),
                          );
                          onLoginPressed('google_token');
                        },
                        child: Text('Sign in with Google'),
                      ),
                    ),
                    Visibility(
                      visible: loginType == 'microsoft',
                      // Show for Microsoft login type
                      child: ElevatedButton(
                        onPressed: () {
                          // Microsoft sign-in logic
                          // Pass necessary parameters to onLoginPressed
                          onLoginPressed(
                              'microsoft_token');
                        },
                        child: Text('Sign in with Microsoft'),
                      ),
                    ),
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
                        // Retrieve username and password from text fields
                        String username = usernameController.text;
                        String password = passwordController.text;

                        // Combine username and password or use only one as token
                        String token = '$username:$password'; // Or any logic you need

                        // Call the onLoginPressed callback with the token, baseUrl, and loginType
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
            );
          },
        ),
      );
    }
  }
  class WebViewScreen extends StatefulWidget {
    final String authUrl;
    final Function(String token) onLoginPressed;

    WebViewScreen({required this.authUrl, required this.onLoginPressed});

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
                widget.onLoginPressed(token);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    }
  }
