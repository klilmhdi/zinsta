import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:stream_video/stream_video.dart' show User, UserInfo, UserToken;
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';

import '../../../components/consts/di.dart';
import '../../../services/getstream_user_creditional_model.dart';
import '../../../services/user_controller.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository}) : _userRepository = userRepository, super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        final fcmToken = await OneSignalNotificationRepository().initializeOneSignal().toString();

        MyUser userFirebase = await _userRepository.signUp(event.user, event.password, fcmToken);
        UserInfo userGetStream = UserInfo(id: event.user.id, name: event.user.name, image: event.user.picture);

        await _userRepository.setUserData(userFirebase);
        log("User registered successfully: $userFirebase");

        // Login user and save credentials
        await locator.get<UserAuthController>().login(
          User(info: userGetStream),
          locator<SharedPrefController>().environment,
        );
        log("User logged in successfully and credentials saved.");

        // Save user credentials in SharedPreferences
        await locator<SharedPrefController>().setUserCredentials(
          UserCredentialsModel(
            token: UserToken.jwt(
              _generateJwt(
                userId: event.user.id,
                secretKey: '7azrmrktn5q59se4nvdetrzepn3gg5v7evuxhkj5x7ydg29hfdcbp9ph483vyhwm',
              ),
            ),
            userInfo: userGetStream,
          ),
        );

        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure());
      }
    });
  }
}

String _generateJwt({required String userId, required String secretKey, int expiryMinutes = 60}) {
  final jwt = JWT({
    'user_id': userId,
    'exp': DateTime.now().add(Duration(minutes: expiryMinutes)).millisecondsSinceEpoch ~/ 1000,
  });
  return jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS256);
}
