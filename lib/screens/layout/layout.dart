import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/appbar_widget.dart';
import 'package:zinsta/components/consts/fab_widget.dart';
import 'package:zinsta/screens/layout/home/notification/notification_screen.dart';

import '../../blocs/cubits/app_cubit/app_cubit.dart';
import 'home/chat/chat_layout.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AppCubit(),
    child: BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return PageView(
          controller: _pageViewController,
          children: [
            Scaffold(
              appBar: buildAppBar(
                context,
                index: cubit.currentIndex,
                onChatPressed: () {
                  _pageViewController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                onNotificationPressed:
                    () => Animations().rtlNavigationAnimation(context, NotificationScreen()),
              ),
              extendBodyBehindAppBar: cubit.currentIndex == 1 ? true : false,
              body: cubit.screens[cubit.currentIndex],
              floatingActionButton: buildFABWidget(),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                items: cubit.items,
                currentIndex: cubit.currentIndex,
                unselectedItemColor: AppBasicsColors.secondaryColor,
                selectedItemColor: AppBasicsColors.primaryColor,
                onTap: (index) => setState(() => cubit.changeBottomNavBar(index)),
              ),
            ),
            if (cubit.currentIndex == 0) ...[ChatLayoutPage()],
          ],
        );
      },
    ),
  );
}
