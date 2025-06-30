import 'package:flutter/material.dart';

import '../consts/text_form_field.dart';

Widget buildProfileEditingFormWidget(
  context, {
  required var formKey,
  required var nameController,
  required var emailController,
  required var usernameController,
  required var bioController,
}) => Form(
  key: formKey,
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      spacing: 10,
      children: [
        buildTextFormFieldWidget(
          context,
          controller: nameController,
          hintText: "Name",
          obscureText: false,
          keyboardType: TextInputType.name,
          length: 30,
        ),
        buildTextFormFieldWidget(
          context,
          controller: usernameController,
          hintText: 'Username',
          obscureText: false,
          keyboardType: TextInputType.name,
          length: 20,
        ),
        buildTextFormFieldWidget(
          context,
          controller: emailController,
          hintText: "Email",
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
        ),
        buildTextFormFieldWidget(
          context,
          controller: bioController,
          hintText: 'Bio',
          obscureText: false,
          keyboardType: TextInputType.multiline,
          minLines: 8,
          maxLines: 12,
          length: 200,
          isNext: false,
        ),
      ],
    ),
  ),
);
