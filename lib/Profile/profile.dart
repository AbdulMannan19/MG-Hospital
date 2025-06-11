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
  String? _userEmail;

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
      _userEmail = Supabase.instance.client.auth.currentUser?.email;
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
      _userEmail = user.email;
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
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child:
                            Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : 'Guest User',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (_userEmail != null)
                        Text(
                          _userEmail!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dobController,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth (YYYY-MM-DD)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _genderController,
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.transgender),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _saveProfile,
                                  icon:
                                      _loading // Use _loading state for the save button
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2),
                                            )
                                          : const Icon(Icons.save),
                                  label: const Text('Save Profile'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
