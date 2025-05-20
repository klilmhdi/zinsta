import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/blocs/auth_blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/leading_appbar.dart';
import 'package:zinsta/screens/layout/settings/change_language_screen.dart';

import '../../../blocs/cubits/app_cubit/app_cubit.dart';
import '../../../components/consts/dialog.dart';

class SettingLayout extends StatelessWidget {
  const SettingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: buildLeadingAppbarWidget(context),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text("Theme", style: TextStyle(fontWeight: FontWeight.bold)),
                leading: HugeIcon(icon: HugeIcons.strokeRoundedColors, size: 20),
                trailing: BlocBuilder<AppCubit, AppState>(
                  buildWhen:
                      (previous, current) =>
                          previous.themeCurrentIndex != current.themeCurrentIndex,
                  builder: (context, state) {
                    AppCubit appCubit = BlocProvider.of(context, listen: false);
                    return Switch.adaptive(
                      activeColor: AppBasicsColors.primaryColor,
                      inactiveThumbColor: CupertinoColors.systemGrey3,
                      value: state.themeCurrentIndex == 0,
                      onChanged: (value) {
                        if (state.themeCurrentIndex == 0) {
                          appCubit.setThemeIndex(themeIndex: 1);
                        } else {
                          appCubit.setThemeIndex(themeIndex: 0);
                        }
                      },
                    );
                  },
                ),
              ),
              _buildSettingWidget(
                context,
                title: "Language",
                screen: ChangeLanguageScreen(),
                icon: HugeIcons.strokeRoundedLanguageCircle,
              ),
              _buildSettingWidget(
                context,
                title: "Save posts",
                screen: Container(),
                icon: HugeIcons.strokeRoundedAllBookmark,
              ),
              _buildSettingWidget(
                context,
                title: "About developer",
                screen: Container(),
                icon: HugeIcons.strokeRoundedCards02,
              ),
              _buildSettingWidget(
                context,
                title: "Rate us",
                screen: Container(),
                icon: HugeIcons.strokeRoundedStarCircle,
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout01,
                  color: CupertinoColors.destructiveRed,
                ),
                onTap:
                    () => customDialog(
                      context,
                      title: "Logout",
                      subtitle: "Do you wanna logout?",
                      outlineButtonText: "No",
                      customButtonText: "Logout",
                      icon: HugeIcons.strokeRoundedLogout01,
                      customButtonFunction:
                          () async => context.read<SignInBloc>().add(const SignOutRequired()),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingWidget(
    context, {
    required String title,
    required Widget screen,
    required IconData icon,
  }) => ListTile(
    leading: HugeIcon(icon: icon, size: 20),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    trailing: HugeIcon(icon: HugeIcons.strokeRoundedCircleArrowRight01, size: 20),
    onTap: () => Animations().rtlNavigationAnimation(context, screen),
  );
}
