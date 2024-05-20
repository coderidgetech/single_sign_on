// config_provider.dart

import 'package:flutter/material.dart';

import 'Config.dart';

class ConfigProvider extends ChangeNotifier {
  late Config _config;

  Config get config => _config;

  void setConfig(Config config) {
    _config = config;
    notifyListeners();
  }
}
