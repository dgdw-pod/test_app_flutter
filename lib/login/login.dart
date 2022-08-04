import 'package:flutter/material.dart';

import '../auth_handler.dart';

class Login extends StatelessWidget {
  final AuthHandler authHandler;
  final void Function() onProgress;
  final void Function(String) onLoggedIn;
  final void Function(String) onError;
  final String? loginError;

  const Login(this.authHandler, this.onProgress, this.onLoggedIn, this.onError,
      this.loginError,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            onProgress();
            try {
              String result = await authHandler.loginAction();
              onLoggedIn(result);
            } catch (e) {
              onError(e.toString());
            }
          },
          child: const Text('Login'),
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}
