part of 'edit_user_info_bloc.dart';

sealed class EditUserInfoState extends Equatable {
  const EditUserInfoState();
}

final class EditUserInfoInitial extends EditUserInfoState {
  @override
  List<Object> get props => [];
}
