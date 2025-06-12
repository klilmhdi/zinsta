import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/screens/layout/profile/profile_screen.dart';

import '../../../components/consts/shared_perferenced.dart';
import '../../../screens/layout/home/home_screen.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  static AppCubit get(context) => BlocProvider.of(context, listen: false);

  /// => Variables
  int currentIndex = 0;
  List<Widget> screens = [const HomeScreen(), const ProfileScreen(isCurrentUser: true)];
  List<NavigationModel> items = [
    NavigationModel(HugeIcon(icon: HugeIcons.strokeRoundedHome01), "Home"),
    NavigationModel(HugeIcon(icon: HugeIcons.strokeRoundedUserCircle), "Profile"),
  ];

  /// => Getter
  ColorScheme themeColorScheme(context) => Theme.of(context).colorScheme;

  /// => Change language
  Future<void> setLanguage({required String? languageCode}) async {
    if (languageCode == null) {
      emit(state.copyWith(languageCode: SharedPrefController().getValueFor(PrKeys.languageCode.name)));
    } else {
      SharedPrefController().setLanguageCode(langCode: languageCode).then((value) {
        emit(state.copyWith(languageCode: languageCode));
      });
    }
  }

  /// => Change Color
  Future<void> setThemeIndex({required int? themeIndex}) async {
    if (themeIndex == null) {
      emit(state.copyWith(themeCurrentIndex: SharedPrefController().getValueFor(PrKeys.themeCurrentIndex.name)));
    } else {
      SharedPrefController().setTheme(themeCurrentIndex: themeIndex).then((value) {
        emit(state.copyWith(themeCurrentIndex: themeIndex));
      });
    }
  }

  /// => Change bottom navigation bar index
  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(ChangeBottomNavigationBarState(index: index));
  }
}

class NavigationModel {
  final String label;
  final HugeIcon icon;

  NavigationModel(this.icon, this.label);
}
