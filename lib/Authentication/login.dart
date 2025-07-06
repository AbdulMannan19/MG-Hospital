import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  int? _resendToken; // For resending the code

  String? _errorMessage; // To display authentication errors

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  // Function to initiate phone number verification
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

    // Hardcoded phone number for now, as requested
    // In a real app, you would use _phoneNumberController.text.trim()
    final String phoneNumberToVerify = '+19132636353';

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberToVerify,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // AUTO-RETRIEVAL ON ANDROID:
          // This callback is invoked automatically when the SMS code is
          // automatically retrieved on Android devices.
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
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
          // Handle errors, e.g., invalid phone number, too many requests
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          // SMS code sent to the phone number
          setState(() {
            _isLoading = false;
            _isCodeSent = true; // Show SMS code input field
            _verificationId = verificationId;
            _resendToken = resendToken; // Store token for resending
            _errorMessage = 'SMS code sent to $phoneNumberToVerify';
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timed out, but the code may still be pending
          setState(() {
            _isLoading = false;
            _verificationId = verificationId; // Still store verification ID
            _errorMessage =
                'SMS code auto-retrieval timed out. Please enter manually.';
          });
        },
        timeout:
            const Duration(seconds: 60), // Set a timeout for auto-retrieval
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

  // Function to sign in with the SMS code
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

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
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
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/mghospital-logo.png', // Ensure this asset exists
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                // Welcome Text
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

                // Error Message Display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Phone Number Input
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number (e.g., +1XXXXXXXXXX)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  // No validator here, as we're hardcoding for now.
                  // In a real app, you'd validate the format.
                ),
                const SizedBox(height: 16),

                // Send Code Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF13a8b4), // A different color for distinction
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

                // SMS Code Input (Conditionally visible)
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
                  ),
                  const SizedBox(height: 16),
                  // Verify Code Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green[700], // Another distinct color
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
