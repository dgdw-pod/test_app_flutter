import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

const authorisationEndpoint =
    'https://auth-staging.pod-point.com/oauth/authorize';
const tokenEndpoint = 'https://auth-staging.pod-point.com/api/v1/oauth/token';
const userInfoEndpoint = 'https://auth-staging.pod-point.com/api/v1/user';
const redirectUrl = 'com.podpoint.testapp://callback';
const identifier = '74';

class AuthHandler {
  final FlutterAppAuth appAuth = const FlutterAppAuth();

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

  Future<String> loginAction() async {
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
      log('token: ${result?.accessToken}');
      debugPrint('token: ${result?.accessToken}');
      final Map<String, dynamic> profile =
          await getUserDetails(result?.accessToken);
      debugPrint('response: $profile');
      return profile['data']['name'];
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      rethrow;
    }
  }

  Future<void> logoutAction() async {}
}
