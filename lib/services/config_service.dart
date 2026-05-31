import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/esp_settings.dart';

class ConfigService extends ChangeNotifier {
  final SharedPreferences _prefs;
  late ESPConfig _config;
  
  ConfigService(this._prefs) {
    _config = ESPConfig();
  }
  
  Future<void> init() async {
    await loadConfig();
  }
  
  ESPConfig get config => _config;
  
  Future<void> loadConfig() async {
    final jsonString = _prefs.getString('esp_config');
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        _config = ESPConfig.fromJson(json);
      } catch (e) {
        _config = ESPConfig();
      }
    }
    notifyListeners();
  }
  
  Future<void> saveConfig() async {
    final jsonString = jsonEncode(_config.toJson());
    await _prefs.setString('esp_config', jsonString);
    notifyListeners();
  }
  
  void updateSetting(void Function(ESPConfig) update) {
    update(_config);
    saveConfig();
  }
}