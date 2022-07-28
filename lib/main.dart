import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

const authorisationEndpoint =
    'https://auth-staging.pod-point.com/oauth/authorize';
const tokenEndpoint = 'https://auth-staging.pod-point.com/api/v1/oauth/token';
const userInfoEndpoint = 'https://auth-staging.pod-point.com/api/v1/user';
const redirectUrl = 'com.podpoint.testapp://callback';
const identifier = '74';

const FlutterAppAuth appAuth = FlutterAppAuth();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String? errorMessage;
  String? name;
  String? picture;

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
                  ? Profile(logoutAction, name, picture)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getUserDetails(String? accessToken) async {
    final http.Response response = await http.get(
      Uri.parse(userInfoEndpoint),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          identifier,
          redirectUrl,
          serviceConfiguration: const AuthorizationServiceConfiguration(
              authorizationEndpoint: authorisationEndpoint,
              tokenEndpoint: tokenEndpoint),
          scopes: <String>[],
        ),
      );
      log('data: $result');
      final Map<String, dynamic> profile =
          await getUserDetails(result?.accessToken);
      debugPrint('response: $profile');
      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = profile['data']['name'];
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> initAction() async {}

  Future<void> logoutAction() async {
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
}

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String? loginError;

  const Login(this.loginAction, this.loginError, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await loginAction();
          },
          child: const Text('Login'),
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}

class Profile extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String? name;
  final String? picture;

  const Profile(this.logoutAction, this.name, this.picture, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            await logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
