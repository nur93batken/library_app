import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_books/src/features/app/bloc/auth_bloc.dart';

import 'package:my_books/src/features/utils/app_show.dart';

import '../../welcome/widgets/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is! AuthLoadingState) {
            Navigator.pop(context);
          }
          if (state is AuthenticatedState) {
            AppShow.navigateHomeUntil(context);
          }
          if (state is AuthErrorState) {
            AppShow.showError(context, state.message);
          }
          if (state is AuthLoadingState) {
            AppShow.showLoading(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              CustomTextField(
                controller: _emailCtl,
                labelText: 'Email',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordCtl,
                labelText: 'Password',
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Login',
                onPressed: () {
                  if (checkForm()) {
                    final registerEvent = AuthLoginEvent(
                      email: _emailCtl.text,
                      password: _passwordCtl.text,
                    );

                    context.read<AuthBloc>().add(registerEvent);
                  } else {
                    log('Form is not valid' as num);
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  bool checkForm() {
    if (_emailCtl.text.isNotEmpty && _passwordCtl.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
