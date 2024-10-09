import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/screens/home/view_notes.dart';
import 'package:supabasedemo/screens/login.dart';
import 'package:supabasedemo/screens/signup.dart';

const databaseUrl = 'YOUR_SUPABASE_URL';
const databaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: databaseUrl,
    anonKey: databaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        'login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/home': (_) => const ViewNotesPage(),
      },
    );
  }
}
