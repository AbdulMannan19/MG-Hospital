import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'Home/home.dart';
import 'Authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide User; // Hide User from Supabase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://tuivyasedfkzbkdnbslp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR1aXZ5YXNlZGZremJrZG5ic2xwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwMjA1NTEsImV4cCI6MjA2NTU5NjU1MX0.10sPx_lMLspGziJKvWkYIHMyI5HIGB-X_X_rYhYTA_Vug',
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
      // Use a StreamBuilder to listen to Firebase authentication state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while the authentication state is being determined
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // If a user is logged in (snapshot.hasData is true), show the HomePage
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            // If no user is logged in, show the LoginPage
            return const LoginPage();
          }
        },
      ),
      routes: {
        // Keep your named routes for navigation within the app
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
