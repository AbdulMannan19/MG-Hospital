import '../globals.dart' as globals;
import '../globals.dart' show Profile;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();

  bool _isLoading = false;
  bool _isCodeSent = false;
  String? _verificationId;
  int? _resendToken;

  String? _errorMessage;
  String _selectedCountryCode = '+1';

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a phone number.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String phoneNumberToVerify =
        _selectedCountryCode + _phoneNumberController.text.trim();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberToVerify,
        verificationCompleted: (PhoneAuthCredential credential) async {
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
          try {
            final UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);

            if (userCredential.user != null) {
              globals.globalUserId = userCredential.user!.uid;
              await _syncUserWithSupabase(userCredential.user!.uid);
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
              _fetchProfileData(userCredential.user!.uid);
            } else {
              setState(() {
                _isLoading = false;
                _errorMessage = 'Failed to get user after sign-in.';
              });
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              _isLoading = false;
              _errorMessage = e.message;
            });
          } catch (e) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'An unexpected error occurred during sign-in: $e';
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _isCodeSent = true;
            _verificationId = verificationId;
            _resendToken = resendToken;
            _errorMessage = 'SMS code sent to $phoneNumberToVerify';
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
            _errorMessage =
                'SMS code auto-retrieval timed out. Please enter manually.';
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  void _signInWithPhoneNumber() async {
    if (_smsCodeController.text.isEmpty || _verificationId == null) {
      setState(() {
        _errorMessage = 'Please enter the SMS code.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeController.text.trim(),
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        globals.globalUserId = userCredential.user!.uid;
        await _syncUserWithSupabase(userCredential.user!.uid);

        // Navigate to home page immediately
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }

        // Load profile data in background (don't await)
        _fetchProfileData(userCredential.user!.uid);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to get user after sign-in.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  Future<void> _syncUserWithSupabase(String firebaseUid) async {
    try {
      // Query for the user by id
      final response = await supabase
          .from('users')
          .select('id')
          .eq('id', firebaseUid)
          .limit(1)
          .execute();

      final List data = response.data as List;

      if (data.isEmpty) {
        final insertResponse =
            await supabase.from('users').insert({'id': firebaseUid}).execute();

        if (insertResponse.status != 201 && insertResponse.status != 200) {
          setState(() {
            _errorMessage =
                'Failed to create user profile: ${insertResponse.status}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during user sync: $e';
      });
    }
  }

  Future<void> _fetchProfileData(String userId) async {
    try {
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

        debugPrint(
            '[LoginPage] Profile data loaded: name=$name, dob=$dateOfBirth, gender=$gender');
      } else {
        debugPrint('[LoginPage] Failed to load profile data during login');
      }
    } catch (e) {
      debugPrint('[LoginPage] Error loading profile data: $e');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/mghospital-logo.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to MG Hospital',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF13a8b4),
                  ),
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountryCode = newValue!;
                          });
                        },
                        items: <String>['+1', '+91']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'e.g., 9132636351',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter digits only';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13a8b4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading && !_isCodeSent
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Send Verification Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                if (_isCodeSent) ...[
                  TextFormField(
                    controller: _smsCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'SMS Verification Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the SMS code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading && _isCodeSent
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Verify Code and Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
