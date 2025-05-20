import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_user_info_event.dart';
part 'edit_user_info_state.dart';

class EditUserInfoBloc extends Bloc<EditUserInfoEvent, EditUserInfoState> {
  EditUserInfoBloc() : super(EditUserInfoInitial()) {
    on<EditUserInfoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
