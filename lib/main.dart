import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication/login.dart';
import 'Home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitializer());
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  Future<bool> _initSupabase() async {
    await Supabase.initialize(
      url: 'https://ncpvxsznsddxtkpnewza.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jcHZ4c3puc2RkeHRrcG5ld3phIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyOTgyMzMsImV4cCI6MjA2MTg3NDIzM30.vBO8W8UCyWcEg_eBuoIfSxySjmnQH5zdajMMzZuCI6M',
    );
    return Supabase.instance.client.auth.currentSession != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initSupabase(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        return MyApp(initialRoute: snapshot.data! ? '/home' : '/login');
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
