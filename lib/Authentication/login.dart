import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final user = session?.user;
      if (user != null) {
        // Check if user exists in users table
        final response = await Supabase.instance.client
            .from('users')
            .select('id')
            .eq('id', user.id)
            .maybeSingle();
        if (response == null) {
          await Supabase.instance.client.from('users').insert({
            'id': user.id,
            'name': null,
            'date_of_birth': null,
            'gender': null,
            'phone_number': null,
          });
        }
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth
                    .signInWithOAuth(OAuthProvider.google);
              },
              child: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
