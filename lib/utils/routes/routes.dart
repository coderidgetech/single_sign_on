import 'dart:async';

import 'package:flutter/material.dart';
import 'package:single_sign_on/view/LoginScreen.dart';
import 'package:single_sign_on/utils/routes/routes_name.dart';
import 'package:single_sign_on/view/Normal.dart';
import 'package:single_sign_on/view/OtpScreen.dart';
import 'package:single_sign_on/view/ldapScreen.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.normal:
        // final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => NormalScreen());

      case RoutesName.otp:
        final args = settings.arguments as Map<String, dynamic>;
        var username = args['username'];
        var call_back = args['call_back'];
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              OTPScreen(username: username, onLoginPressed: call_back),
        );
      case RoutesName.web_view:
        final args = settings.arguments as Map<String, dynamic>;
        var call_back = args['call_back'];
        dynamic authUrl = args['authUrl'];
        AuthViewModel authViewModel = args['authViewModel'];
        print("object");
        return MaterialPageRoute(
            builder: (context) => WebViewScreen(
                  authUrl: authUrl,
                  onLoginPressed: call_back,
                ));

      case RoutesName.ldap:
        final args = settings.arguments as Map<String, dynamic>;
        var tenant = args['tenant'];
        var deviceId = args['deviceId'];
        var appName = args['appName'];
        var call_back = args['call_back'];

        return MaterialPageRoute(
            builder: (BuildContext context) => LDAPLoginScreen(
                tenant: tenant,
                deviceId: deviceId,
                appName: appName,
                onLoginPressed: call_back));

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
