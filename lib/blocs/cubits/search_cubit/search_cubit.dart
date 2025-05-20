import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.userRepository}) : super(const SearchState());

  static SearchCubit get(context) => BlocProvider.of(context, listen: false);

  final UserRepository userRepository;
  TextEditingController searchController = TextEditingController();

  Future<void> searchUsers(String query) async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<MyUser> users = await userRepository.searchUserFromUsername(query);
      print('Fetched users: $users');
      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
