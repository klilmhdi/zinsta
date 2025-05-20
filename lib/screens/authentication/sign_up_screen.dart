import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/components/consts/buttons.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';
import 'package:zinsta/components/consts/text_form_field.dart';

import '../../blocs/auth_blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../components/consts/strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final userNameController = TextEditingController();

  IconData iconPassword = HugeIcons.strokeRoundedView;

  bool signUpRequired = false;
  bool obscurePassword = true;

  /// Username validations
  bool containsUsernameLowerCase = false;
  bool containsUsernameNumber = false;
  bool containsUsername8Length = false;

  /// Password   validations
  bool containsUpperCase = false;
  bool containsPasswordNumber = false;
  bool containsPassword8Length = false;
  bool containsPasswordLowerCase = false;
  bool containsPasswordSpecialChar = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              const SizedBox(height: 10),
              buildTextFormFieldWidget(
                context,
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
                keyboardType: TextInputType.name,
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (val.length > 30) {
                    return 'Name too long';
                  }
                  return null;
                },
              ),
              buildTextFormFieldWidget(
                context,
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMail02),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!AppStrings.emailRexExp.hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              Column(
                spacing: 5,
                children: [
                  buildTextFormFieldWidget(
                    context,
                    controller: userNameController,
                    hintText: 'Username',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedAddressBook),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (val.length > 20) {
                        return 'Username too long';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      if (val!.contains(RegExp(r'[a-z]'))) {
                        setState(() {
                          containsUsernameLowerCase = true;
                        });
                      } else {
                        setState(() {
                          containsUsernameLowerCase = false;
                        });
                      }
                      if (val.contains(RegExp(r'[0-9]'))) {
                        setState(() {
                          containsUsernameNumber = true;
                        });
                      } else {
                        setState(() {
                          containsUsernameNumber = false;
                        });
                      }
                      if (val.length >= 8) {
                        setState(() {
                          containsUsername8Length = true;
                        });
                      } else {
                        setState(() {
                          containsUsername8Length = false;
                        });
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                              color:
                                  containsUsernameLowerCase
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                              color:
                                  containsUsernameNumber
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  8 minimum character",
                            style: TextStyle(
                              color:
                                  containsUsername8Length
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                spacing: 5,
                children: [
                  buildTextFormFieldWidget(
                    context,
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSquareLockPassword),
                    onChanged: (val) {
                      if (val!.contains(RegExp(r'[A-Z]'))) {
                        setState(() {
                          containsUpperCase = true;
                        });
                      } else {
                        setState(() {
                          containsUpperCase = false;
                        });
                      }
                      if (val.contains(RegExp(r'[a-z]'))) {
                        setState(() {
                          containsPasswordLowerCase = true;
                        });
                      } else {
                        setState(() {
                          containsPasswordLowerCase = false;
                        });
                      }
                      if (val.contains(RegExp(r'[0-9]'))) {
                        setState(() {
                          containsPasswordNumber = true;
                        });
                      } else {
                        setState(() {
                          containsPasswordNumber = false;
                        });
                      }
                      if (val.contains(AppStrings.specialCharRexExp)) {
                        setState(() {
                          containsPasswordSpecialChar = true;
                        });
                      } else {
                        setState(() {
                          containsPasswordSpecialChar = false;
                        });
                      }
                      if (val.length >= 8) {
                        setState(() {
                          containsPassword8Length = true;
                        });
                      } else {
                        setState(() {
                          containsPassword8Length = false;
                        });
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!AppStrings.passwordRexExp.hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 uppercase",
                            style: TextStyle(
                              color:
                                  containsUpperCase
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                              color:
                                  containsPasswordLowerCase
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                              color:
                                  containsPasswordNumber
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 special character",
                            style: TextStyle(
                              color:
                                  containsPasswordSpecialChar
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "⚈  8 minimum character",
                            style: TextStyle(
                              color:
                                  containsPassword8Length
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              !signUpRequired
                  ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,

                    child: BasicButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                            email: emailController.text,
                            name: nameController.text,
                            username: userNameController.text,
                          );

                          setState(
                            () => context.read<SignUpBloc>().add(
                              SignUpRequired(myUser, passwordController.text),
                            ),
                          );
                        }
                      },
                      title: "Signup",
                    ),
                  )
                  : basicLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

/*
// ? SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.5,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState!.validate()) {
                  //         MyUser myUser = MyUser.empty;
                  //         myUser = myUser.copyWith(
                  //           email: emailController.text,
                  //           name: nameController.text,
                  //           username: userNameController.text
                  //         );
                  //
                  //         setState(() {
                  //           context.read<SignUpBloc>().add(
                  //             SignUpRequired(myUser, passwordController.text),
                  //           );
                  //         });
                  //       }
                  //     },
                  //     style: TextButton.styleFrom(
                  //       elevation: 3.0,
                  //       backgroundColor: Theme.of(context).colorScheme.primary,
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                  //     ),
                  //     child: const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  //       child: Text(
                  //         'Sign Up',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )*/
