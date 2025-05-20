// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zinsta/services/token_service.dart';
//
// import 'getstream_user_creditional_model.dart';
//
// class AppPreferences {
//   const AppPreferences({required SharedPreferences prefs}) : _prefs = prefs;
//
//   final SharedPreferences _prefs;
//
//
//   EnvEnum get environment =>
//       EnvEnum.fromSubdomain(_prefs.getString(_kEnvironemntPref) ?? EnvEnum.pronto.name);
//
//   UserCredentialsModel? get userCredentials {
//     final jsonString = _prefs.getString(_kUserCredentialsPref);
//     if (jsonString == null) {
//       debugPrint("No user credentials found in SharedPreferences.");
//       return null;
//     }
//
//     try {
//       final json = jsonDecode(jsonString) as Map<String, Object?>;
//       return UserCredentialsModel.fromJson(json);
//     } catch (e) {
//       debugPrint("Error decoding user credentials: $e");
//       return null;
//     }
//   }
//
//   Future<void> setUserCredentials(UserCredentialsModel credentials) async {
//     final jsonString = jsonEncode(credentials.toJson());
//     await _prefs.setString(_kUserCredentialsPref, jsonString);
//     debugPrint("User credentials saved in SharedPreferences.");
//   }
//
//   Future<bool> setApiKey(String apiKey) => _prefs.setString(_kApiKeyPref, apiKey);
//
//   Future<bool> setEnvEnum(EnvEnum env) => _prefs.setString(_kEnvironemntPref, env.name);
//
//   Future<bool> clearUserCredentials() async =>
//       await _prefs.remove(_kUserCredentialsPref) && await _prefs.remove(_kApiKeyPref);
//
//   Future<void> saveCredentials(UserCredentialsModel credentials) async {
//     final prefs = await SharedPreferences.getInstance();
//     final appPrefs = AppPreferences(prefs: prefs);
//
//     await appPrefs.setUserCredentials(credentials);
//     await appPrefs.setApiKey(_kApiKeyPref);
//   }
// }
