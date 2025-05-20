import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, UserInfo;
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';
import 'package:zinsta/components/di.dart';
import 'package:zinsta/services/user_controller.dart';
import 'package:stream_video/stream_video.dart' show User, UserInfo, UserToken;

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        await locator.get<UserAuthController>().login(
          User(info: UserInfo(id: FirebaseAuth.instance.currentUser?.uid ?? "empty id")),
          locator<SharedPrefController>().environment,
        );

        debugPrint(FirebaseAuth.instance.currentUser?.uid ?? "empty id");

        emit(SignInSuccess());
      } catch (e) {
        log(e.toString());
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
