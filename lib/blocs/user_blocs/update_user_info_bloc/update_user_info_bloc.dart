import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;

  UpdateUserInfoBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(UpdateUserInfoInitial()) {
    on<EditUserData>((event, emit) async {
      emit(UpdateUserInfoLoading());
      try {
        await _userRepository.editUserData(
          userId: event.userId,
          user: MyUser(
            id: event.userId,
            email: event.email,
            name: event.name,
            picture: event.profileImagePath ?? (await _userRepository.getMyUser(event.userId)).picture,
            username: event.username,
            bio: event.bio,
            background: event.backgroundImagePath ?? (await _userRepository.getMyUser(event.userId)).background,
            oneSignalPlayerId: event.userId,
            lastSeen: DateTime.now(),
            isOnline: true,
          ),
          profilePicturePath: event.profileImagePath,
          backgroundPicturePath: event.backgroundImagePath,
        );
        // await _userRepository.editUserData(
        //   userId: event.userId,
        //   user: MyUser(
        //     id: event.userId,
        //     email: event.email,
        //     name: event.name,
        //     picture: event.profileImagePath!,
        //     username: event.username,
        //     bio: event.bio,
        //   ),
        //   profilePicturePath: event.profileImagePath,
        //   backgroundPicturePath: event.backgroundImagePath,
        // );
        emit(UpdateUserInfoSuccess());
      } catch (e, s) {
        log(e.toString());
        log(s.toString());
        emit(UpdateUserInfoFailure());
      }
    });
  }
}

// class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
//   final UserRepository _userRepository;
//
//   UpdateUserInfoBloc({
// 		required UserRepository userRepository
// 	}) : 	_userRepository = userRepository,
// 	super(UpdateUserInfoInitial()) {
//     on<UploadPicture>((event, emit) async {
// 			emit(UploadPictureLoading());
//       try {
// 				String userImage = await _userRepository.uploadPicture(event.file, event.userId);
//         emit(UploadPictureSuccess(userImage));
//       } catch (e) {
//         emit(UploadPictureFailure());
//       }
//     });
//   }
// }
