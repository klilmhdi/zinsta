import 'package:flutter/material.dart';

class Animations {
  rtlNavigationAnimation(context, Widget) => Navigator.push(context, RTLScreenAnimation(Widget));

  navFromBottomToTopAnimation(context, Widget) => Navigator.push(context, FromBottomToTop(Widget));
}

class RTLScreenAnimation extends PageRouteBuilder {
  final Widget page;

  RTLScreenAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                  position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                      .animate(animation),
                  child: page);
            });
}

class FromBottomToTop extends PageRouteBuilder {
  final Widget page;

  FromBottomToTop(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return ScaleTransition(
                  alignment: Alignment.bottomCenter, scale: animation, child: child);
            });
}
