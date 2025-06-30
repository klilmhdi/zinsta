import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/blocs/auth_blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:zinsta/src/components/consts/animations.dart';
import 'package:zinsta/src/components/consts/app_color.dart';
import 'package:zinsta/src/screens/authentication/welcome_screen.dart';
import 'package:zinsta/src/screens/layout/settings/change_language_screen.dart';

// import 'package:zinsta/src/services/user_controller.dart';

import '../../../blocs/cubits/app_cubit/app_cubit.dart';

class SettingLayout extends StatelessWidget {
  const SettingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), leading: BackButton(), backgroundColor: Colors.transparent),
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
                  buildWhen: (previous, current) => previous.themeCurrentIndex != current.themeCurrentIndex,
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
              Divider(color: Theme.of(context).dividerColor),
              ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(color: CupertinoColors.destructiveRed, fontWeight: FontWeight.bold),
                ),
                trailing: const HugeIcon(icon: HugeIcons.strokeRoundedLogout01, color: CupertinoColors.destructiveRed),
                onTap: () async {
                  // Store navigator reference before any async operations
                  final navigator = Navigator.of(context, rootNavigator: true);

                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Logout", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          content: const Text(
                            "Do you want to logout?",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            TextButton(child: const Text("No"), onPressed: () => Navigator.of(context).pop(false)),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(AppBasicsColors.primaryColor),
                                shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                              onPressed: () async => Navigator.of(context).pop(true),
                              child: Text("Logout", style: TextStyle(color: CupertinoColors.white)),
                            ),
                          ],
                        ),
                  );

                  if (shouldLogout != true) return;

                  try {
                    // Perform logout operations
                    // await locator.get<UserAuthController>().logout();
                    context.read<SignInBloc>().add(const SignOutRequired());

                    // Navigate to welcome screen using the stored navigator reference
                    navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => WelcomeScreen()), (route) => false);
                  } catch (e) {
                    debugPrint('Logout error: $e');
                    // Show error using the stored navigator context
                    ScaffoldMessenger.of(
                      navigator.context,
                    ).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingWidget(context, {required String title, required Widget screen, required IconData icon}) =>
      ListTile(
        leading: HugeIcon(icon: icon, size: 20),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: HugeIcon(icon: HugeIcons.strokeRoundedCircleArrowRight01, size: 20),
        onTap: () => Animations().rtlNavigationAnimation(context, screen),
      );
}
