import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinsta/services/getstream_user_creditional_model.dart';
import 'package:zinsta/services/token_service.dart';

enum PrKeys { languageCode, themeCurrentIndex, isLogin, menuCurrentIndex, flutterSdkPath }

class SharedPrefController {
  SharedPrefController._();

  static SharedPrefController? _instance;

  late SharedPreferences? _sharedPreferences;

  static const String _kUserCredentialsPref = 'user_credentials';
  static const String _kApiKeyPref = 'z3k88gbquy4a';
  static const String _kEnvironemntPref = 'environment';

  factory SharedPrefController() => _instance ??= SharedPrefController._();

  Future<void> initPreferences() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  T? getValueFor<T>(String key) {
    if (_sharedPreferences!.containsKey(key)) {
      return _sharedPreferences!.get(key) as T;
    }
    return null;
  }

  EnvEnum get environment => EnvEnum.fromSubdomain(
    _sharedPreferences!.getString(_kEnvironemntPref) ?? EnvEnum.pronto.name,
  );

  UserCredentialsModel? get userCredentials {
    final jsonString = _sharedPreferences!.getString(_kUserCredentialsPref);
    if (jsonString == null) {
      debugPrint("No user credentials found in SharedPreferences.");
      return null;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, Object?>;
      return UserCredentialsModel.fromJson(json);
    } catch (e) {
      debugPrint("Error decoding user credentials: $e");
      return null;
    }
  }

  Future<void> setUserCredentials(UserCredentialsModel credentials) async {
    final jsonString = jsonEncode(credentials.toJson());
    await _sharedPreferences!.setString(_kUserCredentialsPref, jsonString);
    debugPrint("User credentials saved in SharedPreferences.");
  }

  Future<bool> setApiKey(String apiKey) => _sharedPreferences!.setString(_kApiKeyPref, apiKey);

  Future<bool> setEnvEnum(EnvEnum env) =>
      _sharedPreferences!.setString(_kEnvironemntPref, env.name);

  Future<bool> clearUserCredentials() async =>
      await _sharedPreferences!.remove(_kUserCredentialsPref) &&
      await _sharedPreferences!.remove(_kApiKeyPref);

  Future<void> saveCredentials(UserCredentialsModel credentials) async {
    final prefs = await SharedPreferences.getInstance();
    // final appPrefs = AppPreferences(prefs: prefs);

    // await appPrefs.setUserCredentials(credentials);
    // await appPrefs.setApiKey(_kApiKeyPref);
  }

  //==================> Set the language
  Future<bool> setLanguageCode({required String langCode}) async =>
      await _sharedPreferences!.setString(PrKeys.languageCode.name, langCode);

  //=========================> Set the Theme
  Future<bool> setTheme({required int themeCurrentIndex}) async =>
      await _sharedPreferences!.setInt(PrKeys.themeCurrentIndex.name, themeCurrentIndex);

  Future<bool> setString({required String key, required String value}) async =>
      await _sharedPreferences!.setString(key, value);

  void clear() async => _sharedPreferences!.clear();

  Future<bool> setIsLogin({required bool value}) async =>
      await _sharedPreferences!.setBool(PrKeys.isLogin.name, value);
}
