import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/screens/home/view_notes.dart';
import 'package:supabasedemo/screens/signup.dart';

import '../services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _supaBaseClient = SupaBaseManager();

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _supaBaseClient.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      if (event == AuthChangeEvent.signedIn) {
        // handle signIn event
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ViewNotesPage(),
            ),
          );
        }
      }
    });
  }

  /// Function to generate a random 16 character string.
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  Future<AuthResponse> _googleSignIn() async {
    /// Update the iOS and Web client ID with your own.
    /// Client ID that you registered with Google Cloud.
    /// Note that in order to perform Google sign in on Android, you need to
    /// provide the web client ID, not the Android client ID.
    final clientId = Platform.isIOS ? 'IOS_CLIENT_ID' : 'ANDROID_CLIENT_ID';

    late final String? idToken;
    late final String? accessToken;
    String? rawNonce;

    /// Use AppAuth to perform Google sign in on iOS
    /// and use GoogleSignIn package for Google sign in on Android
    if (Platform.isIOS) {
      const appAuth = FlutterAppAuth();

      /// Just a random string
      rawNonce = _generateRandomString();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      /// Set as reversed DNS form of Google Client ID + :/ for Google login
      final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

      /// Fixed value for google login
      const discoveryUrl =
          'https://accounts.google.com/.well-known/openid-configuration';

      /// authorize the user by opening the consent page
      final result = await appAuth.authorize(
        AuthorizationRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          nonce: hashedNonce,
          scopes: [
            'openid',
            'email',
            'profile',
          ],
        ),
      );

      /// Request the access and id token to google
      final tokenResult = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          authorizationCode: result.authorizationCode,
          discoveryUrl: discoveryUrl,
          codeVerifier: result.codeVerifier,
          nonce: result.nonce,
          scopes: [
            'openid',
            'email',
          ],
        ),
      );

      accessToken = tokenResult.accessToken;
      idToken = tokenResult.idToken;
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: clientId,
        scopes: [
          'openid',
          'email',
        ],
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      accessToken = googleAuth.accessToken;
      idToken = googleAuth.idToken;
    }

    if (idToken == null) {
      throw 'No ID Token';
    }
    if (accessToken == null) {
      throw 'No Access Token';
    }

    return _supaBaseClient.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
      nonce: rawNonce,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter a valid email'),
                  validator: (String? value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Email is not valid';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _supaBaseClient.signInUser(context,
                          email: _emailController.text,
                          password: _passwordController.text);
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUpPage()));
                  },
                  child: const Text('New User? Create Account')),
              GestureDetector(
                onTap: () {
                  _googleSignIn();
                },
                child: Container(
                  width: 250,
                  height: 50,
                  margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    border: Border.all(
                      color: Colors.blue.shade50,
                      width: 1,
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: SvgPicture.asset(
                              'assets/images/img_googleicon.svg',
                              height: 57,
                              width: 24,
                              fit: BoxFit.cover),
                        ),
                        const Expanded(
                          child: Text(
                            "Login With Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
