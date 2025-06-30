import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zinsta/src/services/getstream_user_creditional_model.dart';
// import 'package:zinsta/src/services/token_service.dart';

enum PrKeys {
  languageCode,
  themeCurrentIndex,
  isLogin,
  menuCurrentIndex,
  flutterSdkPath,
  likesCount,
  commentsCount,
  followersCount,
  followingCount,
}

class SharedPrefController {
  SharedPrefController._();

  static SharedPrefController? _instance;

  late SharedPreferences? _sharedPreferences;

  static const String _kUserCredentialsPref = 'user_credentials';
  static const String _kApiKeyPref = 'z3k88gbquy4a';
  static const String _kEnvironemntPref = 'environment';

  factory SharedPrefController() => _instance ??= SharedPrefController._();

  Future<void> initPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  T? getValueFor<T>(String key) {
    if (_sharedPreferences!.containsKey(key)) {
      return _sharedPreferences!.get(key) as T;
    }
    return null;
  }

  // EnvEnum get environment =>
  //     EnvEnum.fromSubdomain(_sharedPreferences!.getString(_kEnvironemntPref) ?? EnvEnum.pronto.name);
  //
  // UserCredentialsModel? get userCredentials {
  //   final jsonString = _sharedPreferences!.getString(_kUserCredentialsPref);
  //   if (jsonString == null) {
  //     debugPrint("No user credentials found in SharedPreferences.");
  //     return null;
  //   }
  //
  //   try {
  //     final json = jsonDecode(jsonString) as Map<String, Object?>;
  //     return UserCredentialsModel.fromJson(json);
  //   } catch (e) {
  //     debugPrint("Error decoding user credentials: $e");
  //     return null;
  //   }
  // }
  //
  // Future<void> setUserCredentials(UserCredentialsModel credentials) async {
  //   final jsonString = jsonEncode(credentials.toJson());
  //   await _sharedPreferences!.setString(_kUserCredentialsPref, jsonString);
  //   debugPrint("User credentials saved in SharedPreferences.");
  // }
  //
  // Future<bool> setApiKey(String apiKey) => _sharedPreferences!.setString(_kApiKeyPref, apiKey);
  //
  // Future<bool> setEnvEnum(EnvEnum env) => _sharedPreferences!.setString(_kEnvironemntPref, env.name);

  Future<bool> clearUserCredentials() async =>
      await _sharedPreferences!.remove(_kUserCredentialsPref) && await _sharedPreferences!.remove(_kApiKeyPref);

  //==================> Set the language
  Future<bool> setLanguageCode({required String langCode}) async =>
      await _sharedPreferences!.setString(PrKeys.languageCode.name, langCode);

  //=========================> Set the Theme
  Future<bool> setTheme({required int themeCurrentIndex}) async =>
      await _sharedPreferences!.setInt(PrKeys.themeCurrentIndex.name, themeCurrentIndex);

  Future<bool> setString({required String key, required String value}) async =>
      await _sharedPreferences!.setString(key, value);

  void clear() async => _sharedPreferences!.clear();

  Future<bool> setIsLogin({required bool value}) async => await _sharedPreferences!.setBool(PrKeys.isLogin.name, value);

  Future<bool> setPostLikesCount(String postId, int count) async =>
      await _sharedPreferences!.setInt('${PrKeys.likesCount.name}_$postId', count);

  int getPostLikesCount(String postId) => _sharedPreferences!.getInt('${PrKeys.likesCount.name}_$postId') ?? 0;

  // Methods for post comments count
  Future<bool> setPostCommentsCount(String postId, int count) async =>
      await _sharedPreferences!.setInt('${PrKeys.commentsCount.name}_$postId', count);

  int getPostCommentsCount(String postId) => _sharedPreferences!.getInt('${PrKeys.commentsCount.name}_$postId') ?? 0;

  // Methods for user followers count
  Future<bool> setUserFollowersCount(String userId, int count) async =>
      await _sharedPreferences!.setInt('${PrKeys.followersCount.name}_$userId', count);

  int getUserFollowersCount(String userId) => _sharedPreferences!.getInt('${PrKeys.followersCount.name}_$userId') ?? 0;

  // Methods for user following count
  Future<bool> setUserFollowingCount(String userId, int count) async =>
      await _sharedPreferences!.setInt('${PrKeys.followingCount.name}_$userId', count);

  int getUserFollowingCount(String userId) => _sharedPreferences!.getInt('${PrKeys.followingCount.name}_$userId') ?? 0;

  // Clear all post-related preferences
  Future<void> clearPostData(String postId) async {
    await _sharedPreferences!.remove('${PrKeys.likesCount.name}_$postId');
    await _sharedPreferences!.remove('${PrKeys.commentsCount.name}_$postId');
  }

  // Clear all user-related preferences
  Future<void> clearUserData(String userId) async {
    await _sharedPreferences!.remove('${PrKeys.followersCount.name}_$userId');
    await _sharedPreferences!.remove('${PrKeys.followingCount.name}_$userId');
  }
}
