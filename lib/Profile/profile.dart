import 'package:flutter/material.dart';
import '../globals.dart' as globals;

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
    _loadProfileFromGlobal();
  }

  void _loadProfileFromGlobal() {
    if (globals.globalProfile != null) {
      setState(() {
        _name = globals.globalProfile!.name;
        _dob = globals.globalProfile!.dateOfBirth;
        _gender = globals.globalProfile!.gender;
        _isLoading = false;
      });
      debugPrint(
          '[ProfilePage] Using global profile data: name=$_name, dob=$_dob, gender=$_gender');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No profile data available';
      });
    }
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
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF13a8b4),
                        child:
                            Icon(Icons.person, size: 60, color: Colors.white),
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
                    ],
                  ),
                ),
    );
  }
}
