import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/screens/home/view_notes.dart';
import 'package:supabasedemo/screens/login.dart';
import 'package:supabasedemo/screens/signup.dart';

const databaseUrl = 'https://owoiiwnpyreqyudsjlfn.supabase.co';
const databaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im93b2lpd25weXJlcXl1ZHNqbGZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgwMzQ1MjgsImV4cCI6MjA0MzYxMDUyOH0.9clsZAuYaD8XLd4sEJMsEmeVR3xnO_kiAcZ1nZSIE7M';
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
