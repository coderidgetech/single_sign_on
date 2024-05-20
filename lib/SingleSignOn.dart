// single_sign_on.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/AuthProvider.dart';

import 'Config.dart';

class SingleSignOn {
  static Widget initialize() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
    );
  }
}
