part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<MyUser> users;
  final bool isLoading;
  final String error;

  const SearchState({
    this.users = const [],
    this.isLoading = false,
    this.error = '',
  });

  SearchState copyWith({
    List<MyUser>? users,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [users, isLoading, error];
}
