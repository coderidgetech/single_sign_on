// config_provider.dart
import 'package:flutter/material.dart';

class Config {
  final String baseUrl;
  final String tenant;
  final String loginType;
  final String deviceId;
  final String appName;

  Config({
    required this.baseUrl,
    required this.tenant,
    required this.loginType,
    required this.deviceId,
    required this.appName
  });
}

class ConfigProvider extends ChangeNotifier {
  late Config _config;

  Config get config => _config;

  void setConfig(Config config) {
    _config = config;
    notifyListeners();
  }
}
