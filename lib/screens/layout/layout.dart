import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/appbar_widget.dart';
import 'package:zinsta/components/consts/bottom_nav_bar.dart';
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
                onNotificationPressed: () => Animations().rtlNavigationAnimation(context, NotificationScreen()),
              ),
              extendBodyBehindAppBar: cubit.currentIndex == 1 ? true : false,
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: buildBottomNavBar(
                items: cubit.items,
                currentIndex: cubit.currentIndex,
                onTap: (value) => setState(() => cubit.changeBottomNavBar(value)),
              ),
            ),
            if (cubit.currentIndex == 0) ...[ChatLayoutPage()],
          ],
        );
      },
    ),
  );
}
