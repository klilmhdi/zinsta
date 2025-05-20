import 'package:flutter/material.dart';
import 'package:zinsta/components/consts/app_color.dart';

Widget buildTextFormFieldWidget(
  context, {
  required bool obscureText,
  required TextInputType keyboardType,
  required String hintText,
  VoidCallback? onTap,
  FocusNode? focusNode,
  TextEditingController? controller,
  String? initialValue,
  String? Function(String?)? validator,
  String? errorMsg,
  String? Function(String?)? onChanged,
  Widget? suffixIcon,
  Widget? prefixIcon,
  int? maxLines,
  int? minLines,
  int? length,
  bool isNext = true,
}) => SizedBox(
  width: MediaQuery.of(context).size.width * 0.9,
  child: TextFormField(
    initialValue: initialValue,
    controller: initialValue == null ? controller : null,
    validator: validator,
    obscureText: obscureText,
    keyboardType: keyboardType,
    focusNode: focusNode,
    onTap: onTap,
    minLines: minLines,
    maxLines: maxLines ?? 1,
    maxLength: length,
    textInputAction: isNext == true ? TextInputAction.next : TextInputAction.newline,
    onChanged: onChanged,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppBasicsColors.lightBackground.withValues(alpha: 0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppBasicsColors.lightBackground.withValues(alpha: 0.4)),
      ),
      fillColor: AppBasicsColors.secondaryColor.withValues(alpha: 0.05),
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600),
      errorText: errorMsg,
    ),
  ),
);
