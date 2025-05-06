import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileCache {
  static Map<String, dynamic>? profile;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Check cache first unless forceRefresh is true
    if (!forceRefresh && ProfileCache.profile != null) {
      _setControllers(ProfileCache.profile!);
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No user found.';
          _loading = false;
        });
        return;
      }
      final response = await Supabase.instance.client
          .from('users')
          .select('name, date_of_birth, gender, phone_number')
          .eq('id', user.id)
          .maybeSingle();
      if (response != null) {
        ProfileCache.profile = response; // Cache it
        _setControllers(response);
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  void _setControllers(Map<String, dynamic> data) {
    _nameController.text = data['name'] ?? '';
    _dobController.text = data['date_of_birth'] ?? '';
    _genderController.text = data['gender'] ?? '';
    _phoneController.text = data['phone_number'] ?? '';
  }

  Future<void> _saveProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No user found.';
          _loading = false;
        });
        return;
      }
      await Supabase.instance.client.from('users').update({
        'name': _nameController.text,
        'date_of_birth': _dobController.text,
        'gender': _genderController.text,
        'phone_number': _phoneController.text,
      }).eq('id', user.id);
      ProfileCache.profile = {
        'name': _nameController.text,
        'date_of_birth': _dobController.text,
        'gender': _genderController.text,
        'phone_number': _phoneController.text,
      };
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              ProfileCache.profile = null;
              await _fetchProfile(forceRefresh: true);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text(_error!)
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: _dobController,
                          decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                        ),
                        TextField(
                          controller: _genderController,
                          decoration: const InputDecoration(labelText: 'Gender'),
                        ),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone Number'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
} 