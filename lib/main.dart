import 'package:flutter/material.dart';
import 'package:test_app_flutter/auth_handler.dart';

import 'login/login.dart';
import 'profile/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String? errorMessage;
  String? name;
  String? picture;
  final AuthHandler authHandler = AuthHandler();

  void onProgress() {
    setState(() {
      isBusy = true;
      name = '';
      errorMessage = '';
    });
  }

  void onLoggedIn(String name) {
    setState(() {
      isBusy = false;
      isLoggedIn = true;
      this.name = name;
    });
  }

  void onError(String error) {
    setState(() {
      isBusy = false;
      isLoggedIn = false;
      name = '';
      errorMessage = error;
    });
  }

  void onLoggedOut() {
    setState(() {
      isBusy = false;
      isLoggedIn = false;
      name = '';
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OAuth Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OAuth Flutter Demo'),
        ),
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
                  ? Profile(authHandler, onLoggedOut, name, picture)
                  : Login(authHandler, onProgress, onLoggedIn, onError,
                      errorMessage),
        ),
      ),
    );
  }
}
