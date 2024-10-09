import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/main.dart';

class SupaBaseManager {
  final client = SupabaseClient(databaseUrl, databaseAnonKey);

  Future<void> signUpUser(context, {String? email, String? password}) async {
    debugPrint("email:$email password:$password");
    final result = await client.auth.signUp(
      password: password!,
      email: email!,
    );

    if (result.user != null) {
      Fluttertoast.showToast(msg: "Registration Success");
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      Fluttertoast.showToast(msg: "Registration Failed");
    }
  }

  Future<void> signInUser(context, {String? email, String? password}) async {
    debugPrint("email:$email password:$password");

    final result = await client.auth
        .signInWithPassword(password: password!, email: email!);

    if (result.user != null) {
      Fluttertoast.showToast(msg: "Login Success");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }

  Future<void> logout(context) async {
    await client.auth.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }
}
