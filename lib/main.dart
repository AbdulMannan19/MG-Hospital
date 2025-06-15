import 'package:flutter/material.dart';
import 'Home/home.dart';
import 'Authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tuivyasedfkzbkdnbslp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR1aXZ5YXNlZGZremJrZG5ic2xwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwMjA1NTEsImV4cCI6MjA2NTU5NjU1MX0.10sPx_lMLspGziJKvWkYIHMyI5HIGB-X_rYhYTA_Vug',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MG Hospital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
