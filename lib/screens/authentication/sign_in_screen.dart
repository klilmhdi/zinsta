import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/blocs/notification_blocs/notificaiton_bloc.dart';
import 'package:zinsta/components/consts/buttons.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';
import 'package:zinsta/components/consts/text_form_field.dart';

import '../../blocs/auth_blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../components/consts/strings.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;

  IconData iconPassword = HugeIcons.strokeRoundedView;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildTextFormFieldWidget(
              context,
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMail02),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!AppStrings.emailRexExp.hasMatch(val)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextFormFieldWidget(
              context,
              controller: passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSquareLockPassword),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!AppStrings.passwordRexExp.hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = HugeIcons.strokeRoundedView;
                    } else {
                      iconPassword = HugeIcons.strokeRoundedViewOffSlash;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
            const SizedBox(height: 20),
            !signInRequired
                ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: BasicButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(SignInRequired(emailController.text, passwordController.text));
                        context.read<NotificationBloc>().add(
                          UpdateOneSignalPlayerId(FirebaseAuth.instance.currentUser?.uid ?? "Empty"),
                        );
                      }
                    },
                    title: "Sign In",
                  ),
                )
                : basicLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
