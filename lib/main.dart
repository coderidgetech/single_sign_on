import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/utils/routes/routes.dart';
import 'package:single_sign_on/view/Normal.dart';
import 'package:single_sign_on/view/PreLogin.dart';
import 'package:single_sign_on/view_model/auth_view_model.dart';

void main() {
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
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final String loginTypes =
            ['ldap', 'google', 'microsoft'].toString();
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Prelogin(
                            onLoginPressed: (token) {
                              // Handle login token
                              print(
                                  '======sdd=d=d=======>> Login token: $token');
                              // Utils.toastMessage("TOKEN : " + token);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NormalScreen()),
                              );
                            },
                            baseUrl: 'https://portal.mdmdev.tectoro.com',

                            // Set your base URL
                            havingManagedConfig: true,
                            tenant: 'TT',
                            deviceID: '351110795908267f',
                            appName: 'securechat',
                            loginTypes: loginTypes,
                          )));
                },
                child: Text('click here'),
              ),
            );
          },
        ),
      ),
    );
  }
}
