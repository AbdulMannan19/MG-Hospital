import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  String? _dob;
  String? _gender;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '[ProfilePage] initState: Fetching profile for userId: \\${globals.globalUserId}');
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final supabase = Supabase.instance.client;
    try {
      debugPrint(
          '[ProfilePage] _fetchProfile: Querying Supabase for userId: \\${globals.globalUserId}');
      final response = await supabase
          .from('users')
          .select('name, date_of_birth, gender')
          .eq('id', globals.globalUserId)
          .single()
          .execute();
      debugPrint(
          '[ProfilePage] _fetchProfile: Supabase response status: \\${response.status}, data: \\${response.data}');
      if (response.status == 200 && response.data != null) {
        setState(() {
          _name = response.data['name'] ?? '';
          _dob = response.data['date_of_birth'] ?? '';
          _gender = _genderString(response.data['gender']);
          _isLoading = false;
        });
        debugPrint(
            '[ProfilePage] _fetchProfile: Profile loaded: name=\\${_name}, dob=\\${_dob}, gender=\\${_gender}');
      } else {
        setState(() {
          _errorMessage = 'Failed to load profile data.';
          _isLoading = false;
        });
        debugPrint(
            '[ProfilePage] _fetchProfile: Failed to load profile data. Status: \\${response.status}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: \\${e}';
        _isLoading = false;
      });
      debugPrint('[ProfilePage] _fetchProfile: Exception: \\${e}');
    }
  }

  String _genderString(dynamic genderValue) {
    if (genderValue == null) return '';
    if (genderValue == 1) return 'Male';
    if (genderValue == 2) return 'Female';
    return genderValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF13a8b4),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF13a8b4),
                        child: const Icon(Icons.person,
                            size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _name ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        _dob ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        _gender ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      // You can add an edit button here if you want
                    ],
                  ),
                ),
    );
  }
}
