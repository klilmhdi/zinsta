import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zinsta/components/consts/app_color.dart';

Widget basicLoadingIndicator() =>
    Center(child: LoadingAnimationWidget.beat(color: AppBasicsColors.primaryColor, size: 50));
