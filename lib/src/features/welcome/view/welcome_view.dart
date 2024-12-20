import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_books/src/features/app/bloc/auth_bloc.dart';
import 'package:my_books/src/features/utils/app_show.dart';
import 'package:my_books/src/features/welcome/widgets/widgets.dart';
import '../../authentication/authentication.dart';

class WellComeView extends StatelessWidget {
  const WellComeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellcome to Library'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            AppShow.navigateHomeUntil(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is UnauthenticatedState) {
                    return CustomElevatedButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LoginView(),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is UnauthenticatedState) {
                    return CustomElevatedButton(
                      text: 'Register',
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const RegisterView(),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
