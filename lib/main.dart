import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home/home.dart';
import 'Authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'globals.dart' as globals;
import 'globals.dart' show Profile;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const supabaseUrl = 'https://tuivyasedfkzbkdnbslp.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR1aXZ5YXNlZGZremJrZG5ic2xwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwMjA1NTEsImV4cCI6MjA2NTU5NjU1MX0.10sPx_lMLspGziJKvWkYIHMyI5HIGB-X_rYhYTA_Vug';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _fetchProfileDataOnRestore(String userId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('users')
          .select('name, date_of_birth, gender, is_admin')
          .eq('id', userId)
          .single()
          .execute();

      if (response.status == 200 && response.data != null) {
        final data = response.data;
        final name = data['name'] ?? '';
        final dateOfBirth = data['date_of_birth'] ?? '';
        final gender = _genderToString(data['gender']);
        final isAdmin = data['is_admin'] ?? false;

        globals.globalProfile = Profile(
          name: name,
          dateOfBirth: dateOfBirth,
          gender: gender,
          isAdmin: isAdmin,
        );
      }
    } catch (e) {
      print('[MyApp] Error restoring profile data: $e');
    }
  }

  String _genderToString(dynamic genderValue) {
    if (genderValue == null) return '';
    if (genderValue == 1) return 'Male';
    if (genderValue == 2) return 'Female';
    return genderValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MG Hospital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            if (globals.globalUserId == null) {
              globals.globalUserId = snapshot.data!.uid;
              _fetchProfileDataOnRestore(snapshot.data!.uid);
            }
            return const HomePage();
          } else {
            globals.globalUserId = null;
            globals.globalProfile = null;
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
