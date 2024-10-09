import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CommonUtils {
  static Future<Map<String, String>> googleSignInIOS(String clientId) async {
    const appAuth = FlutterAppAuth();
    final rawNonce = _generateRandomString();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
    final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';
    const discoveryUrl =
        'https://accounts.google.com/.well-known/openid-configuration';

    final result = await appAuth.authorize(
      AuthorizationRequest(
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        nonce: hashedNonce,
        scopes: ['openid', 'email', 'profile'],
      ),
    );

    final tokenResult = await appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        authorizationCode: result.authorizationCode,
        discoveryUrl: discoveryUrl,
        codeVerifier: result.codeVerifier,
        nonce: result.nonce,
        scopes: ['openid', 'email'],
      ),
    );

    return {
      'accessToken': tokenResult.accessToken!,
      'idToken': tokenResult.idToken!,
    };
  }

  static Future<Map<String, String>> googleSignInAndroid(
      String clientId) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: clientId,
      scopes: ['openid', 'email'],
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    return {
      'accessToken': googleAuth.accessToken!,
      'idToken': googleAuth.idToken!,
    };
  }

  static String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
