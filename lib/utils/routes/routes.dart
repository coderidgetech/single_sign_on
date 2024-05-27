import 'package:flutter/material.dart';
import 'package:single_sign_on/view/LoginScreen.dart';
import 'package:single_sign_on/utils/routes/routes_name.dart';
import 'package:single_sign_on/view/Normal.dart';
import 'package:single_sign_on/view/OtpScreen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.normal:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => Normal(mapJson: args,));

      case RoutesName.otp:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                OTPScreen(username: args['username']));
      case RoutesName.splash:
      // return MaterialPageRoute(builder: (BuildContext context) => const SplashView());

      case RoutesName.home:
      // return MaterialPageRoute(
      //     builder: (BuildContext context) => OTPScreen());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(
                  onLoginPressed: (token) {
                    // Handle login token
                    print('========>> Login token: $token');
                  },
                  onSignUpPressed: () {
                    // Handle sign up
                    print('Sign up pressed');
                  },
                  baseUrl: 'https://portal.emmdev.tectoro.com/idm/v1',
                  // Set your base URL
                  loginType: 'google',
                  // or 'microsoft' or 'ldap'
                  tenant: 'TT',
                  deviceID: '351110795908267f',
                  appName: 'device_care',
                ));
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
