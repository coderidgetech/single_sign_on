import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/AuthProvider.dart';
import 'package:single_sign_on/utils/routes/routes.dart';
import 'package:single_sign_on/utils/routes/routes_name.dart';
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
        initialRoute: RoutesName.login,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
