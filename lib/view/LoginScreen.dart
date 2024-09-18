import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/res/Constants.dart';
import 'package:single_sign_on/utils/apputil.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/routes/routes_name.dart';
import 'package:flutter_svg/flutter_svg.dart';
class LoginScreen extends StatefulWidget {
  final Function(String token) onLoginPressed;
  final String baseUrl;
  final String tenant;
  final String deviceID;
  final String appName;
  final String loginTypes;
  final bool havingManagedConfig;
  LoginScreen({
    required this.onLoginPressed,
    required this.baseUrl,
    required this.tenant,
    required this.deviceID,
    required this.appName,
    required this.loginTypes,
    required this.havingManagedConfig,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<AuthViewModel>(
        builder: (context, authProvider, _) {
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backg.png'),
                  fit: BoxFit.fill, // Adjust as needed
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SvgPicture.asset('lib/assets/tectoro.svg'),
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
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Username',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintText: 'Enter Username',
                                    hintStyle: TextStyle(color: Color(0xffCECECF)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xffCECECF), width: 1.0), // Grey border
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xffCECECF), width: 1.0), // Grey border on focus
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Password',
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(color: Color(0xffCECECF)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xffCECECF), width: 1.0), // Grey border
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xffCECECF), width: 1.0), // Grey border on focus
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                ElevatedButton(
                                  onPressed: () {
                                    String username = usernameController.text.trim();
                                    String password = passwordController.text;
                                    if (username.isEmpty || password.isEmpty || password.length < 2) {
                                      Utils.flushBarErrorMessage(
                                        "Please enter a valid username or password",
                                        context,
                                      );
                                    } else {
                                      hitLoginApi(
                                        context,
                                        authViewModel,
                                        widget.tenant,
                                        username,
                                        password,
                                        widget.onLoginPressed,
                                        widget.baseUrl,
                                      );
                                    }
                                  },
                                  child: Text('Login'),
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
                                ),
                                SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                      visible: widget.loginTypes.contains('google'),
                                      child: Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(8.0),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            handlingGoogleAuthAndMicrosoft(
                                              context,
                                              authViewModel,
                                              widget.onLoginPressed,
                                              'google',
                                              widget.baseUrl,
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'lib/assets/google.svg', // Path to your Google SVG icon
                                            width: 32.0,
                                            height: 32.0,
                                          ),
                                          tooltip: 'Sign in with Google',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Visibility(
                                      visible: widget.loginTypes.contains('microsoft'),
                                      child:Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(8.0),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            handlingGoogleAuthAndMicrosoft(
                                              context,
                                              authViewModel,
                                              widget.onLoginPressed,
                                              'microsoft',
                                              widget.baseUrl,
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'lib/assets/microsoft.svg', // Path to your Microsoft SVG icon
                                            width: 32.0,
                                            height: 32.0,
                                          ),
                                          tooltip: 'Sign in with Microsoft',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Visibility(
                                      visible: widget.loginTypes.contains('ldap'),
                                      child: Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(8.0),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, RoutesName.ldap, arguments: {
                                              'tenant': widget.tenant,
                                              'deviceId': widget.deviceID,
                                              'appName': widget.appName,
                                              'call_back': widget.onLoginPressed,
                                              'baseUrl': widget.baseUrl,
                                            });
                                          },
                                          icon: Image.asset(
                                            'lib/assets/ldap1.png', // Path to your LDAP icon
                                            width: 32.0,
                                            fit: BoxFit.fill,
                                          ),
                                          tooltip: 'Sign in with LDAP',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),),
                        ),),
                      SizedBox(height: 40,),
                      if (authViewModel.loading)
                        Center(
                          child: Container(
                            width: 50,
                            child: LinearProgressIndicator(color: Colors.teal,),
                          ),
                        )
                    ],
                  ),
                ),
              )
          );
        },
      ),
    );
  }
  void handlingGoogleAuthAndMicrosoft(
      BuildContext context,
      AuthViewModel authViewModel,
      Function(String token) onLoginPressed,
      String loginTypeee,
      String baseUrl) {
    Map<String, String> queryParams = {
      'tenant': widget.tenant,
      'mode': loginTypeee,
      'device': widget.deviceID,
      'app': widget.appName,
    };
    authViewModel.googlesigin(queryParams, context, baseUrl).then((authUrl) {
      Navigator.pushNamed(context, RoutesName.web_view, arguments: {
        'authUrl': authUrl,
        'call_back': onLoginPressed,
        'authViewModel': authViewModel,
        'baseUrl': baseUrl
      }).then((token) {
        if (token != null) {
          widget.onLoginPressed(token as String);
        }
      });
    });
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
    authViewModel.loginApi(jsonEncode(data), context, onLoginPressed, baseUrl);
  }
  void saveInCache(
      String baseUrl, String tenant, String deviceID, String appName) async {
// await SharedPrefs.saveString(Constants.baseUrl, baseUrl);
// await SharedPrefs.saveString(Constants.tenant, tenant);
// await SharedPrefs.saveString(Constants.deviceID, deviceID);
// await SharedPrefs.saveString(Constants.appName, appName);
  }
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
        backgroundColor: Color(0xff335BBA),
        foregroundColor: Colors.white,
        title: Text('Sign In'),
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
          String baseUrl = widget.baseUrl;
          print("=========>>>> Base url in web view is : " + baseUrl);
          if (request.url.startsWith(baseUrl)) {
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
                  jsonEncode(data), widget.onLoginPressed, widget.baseUrl);
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