part of 'app_cubit.dart';

class AppState extends Equatable {
  final String languageCode;
  final int themeCurrentIndex;

  const AppState({this.languageCode = 'ar', this.themeCurrentIndex = 0});

  @override
  List<Object> get props => [languageCode, themeCurrentIndex];

  AppState copyWith({String? languageCode, int? themeCurrentIndex}) {
    return AppState(
        languageCode: languageCode ?? this.languageCode,
        themeCurrentIndex: themeCurrentIndex ?? this.themeCurrentIndex);
  }
}

class ChangeBottomNavigationBarState extends AppState {
  const ChangeBottomNavigationBarState({required int index});
}
