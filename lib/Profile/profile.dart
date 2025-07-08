import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import '../globals.dart' show Profile;
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool _isEditing = false;

  // Controllers for edit mode
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

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

      // Initialize controllers with current values
      _nameController.text = _name ?? '';
      _dobController.text = _dob ?? '';
      _selectedGender = _gender;

      debugPrint(
          '[ProfilePage] Using global profile data: name=$_name, dob=$_dob, gender=$_gender');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No profile data available';
      });
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _nameController.text = _name ?? '';
      _dobController.text = _dob ?? '';
      _selectedGender = _gender;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.text = _name ?? '';
      _dobController.text = _dob ?? '';
      _selectedGender = _gender;
    });
  }

  Future<void> _saveProfile() async {
    // Validate name
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    if (_nameController.text.length > 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be 25 characters or less')),
      );
      return;
    }

    // Validate DOB
    if (_dobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return;
    }

    // Validate gender
    if (_selectedGender == null || _selectedGender!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      await supabase.from('users').update({
        'name': _nameController.text.trim(),
        'date_of_birth': _dobController.text,
        'gender': _selectedGender == 'Male' ? 1 : 2,
      }).eq('id', globals.globalUserId);

      setState(() {
        _name = _nameController.text.trim();
        _dob = _dobController.text;
        _gender = _selectedGender;
        _isEditing = false;
        _isLoading = false;
      });

      // Update global profile
      globals.globalProfile = Profile(
        name: _name,
        dateOfBirth: _dob,
        gender: _gender,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
        actions: [
          if (!_isEditing && _name != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _startEditing,
            ),
        ],
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
                      if (!_isEditing) ...[
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
                      ] else ...[
                        // Edit Mode
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            hintText: 'Enter your name',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name cannot be empty';
                            }
                            if (value.length > 25) {
                              return 'Name must be 25 characters or less';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: _selectDate,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Male', child: Text('Male')),
                            DropdownMenuItem(
                                value: 'Female', child: Text('Female')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _cancelEditing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF13a8b4),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
