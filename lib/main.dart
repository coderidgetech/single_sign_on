import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/AuthProvider.dart';
import 'package:single_sign_on/utils/routes/routes.dart';
import 'package:single_sign_on/utils/routes/routes_name.dart';
import 'package:single_sign_on/view/LoginScreen.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // getIt.registerLazySingleton<AuthRepository>(() => AuthHttpApiRepository());
  // getIt.registerLazySingleton<HomeRepository>(() => HomeHttpApiRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // this is the initial route indicating from where our app will start
        // initialRoute: RoutesName.login,
        // onGenerateRoute: Routes.generateRoute,
        home: LoginScreen(
          onLoginPressed: (token) {
            // Handle login token
            print("object");
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
        ),
      ),
    );
  }
}
