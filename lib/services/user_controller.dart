import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide User;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';
import 'package:zinsta/components/consts/di.dart';
import 'package:zinsta/services/getstream_user_creditional_model.dart';
import 'package:zinsta/services/token_service.dart';
import 'package:zinsta/services/user_auth_repo.dart';
import 'package:zinsta/services/user_chat_repo.dart';

class UserAuthController extends ChangeNotifier {
  UserAuthController({required SharedPrefController prefs, required TokenService tokenService})
    : _prefs = prefs,
      _tokenService = tokenService;

  final SharedPrefController _prefs;
  final TokenService _tokenService;

  UserAuthRepository? _authRepo;

  UserInfo? _currentUser;

  // Returns the current user
  UserInfo? get currentUser => _currentUser;

  Future<UserCredentialsModel> login(User user, EnvEnum environment) async {
    final tokenResponse = await _tokenService.loadToken(userId: user.id, environment: environment);

    await _prefs.setApiKey(tokenResponse.apiKey);
    await _prefs.setEnvEnum(environment);

    // Initialize auth repository
    _authRepo ??= locator.get<UserAuthRepository>(param1: user, param2: tokenResponse);

    // Login and get user credentials
    final credentials = await _authRepo!.login();

    // Sync the current user info with the returned credentials
    _currentUser = credentials.userInfo;

    // If not anonymous, store the credentials
    if (_authRepo!.currentUserType != UserType.anonymous) {
      await _prefs.setUserCredentials(credentials);
    }

    notifyListeners();
    return credentials;
  }

  Future<void> logout() async {
    _currentUser = null;
    if (_authRepo != null) {
      await _authRepo!.logout();
      _authRepo = null;
      locator.unregister<StreamVideo>();
      locator.unregister<StreamChatClient>();
      locator.unregister<UserChatRepository>();
    }
    await _prefs.clearUserCredentials();
    notifyListeners();
  }
}
