// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneNumberController = TextEditingController();
//   final _smsCodeController = TextEditingController();

//   bool _isLoading = false;
//   bool _isCodeSent = false;
//   String? _verificationId;
//   int? _resendToken; // For resending the code

//   String? _errorMessage; // To display authentication errors
//   String _selectedCountryCode = '+1'; // Default to American country code

//   final SupabaseClient supabase = Supabase.instance.client;

//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     _smsCodeController.dispose();
//     super.dispose();
//   }

//   void _verifyPhoneNumber() async {
//     if (_phoneNumberController.text.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter a phone number.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final String phoneNumberToVerify =
//         _selectedCountryCode + _phoneNumberController.text.trim();

//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumberToVerify,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           setState(() {
//             _isLoading = true;
//             _errorMessage = null;
//           });
//           try {
//             // await FirebaseAuth.instance.signInWithCredential(credential);
//             final UserCredential userCredential =
//                 await FirebaseAuth.instance.signInWithCredential(credential);

//             if (userCredential.user != null) {
//               await _syncUserWithSupabase(userCredential.user!.uid);
//               if (mounted) {
//                 Navigator.pushReplacementNamed(context, '/home');
//               }
//             }
//           } on FirebaseAuthException catch (e) {
//             setState(() {
//               _isLoading = false;
//               _errorMessage = e.message;
//             });
//           } catch (e) {
//             setState(() {
//               _isLoading = false;
//               _errorMessage = 'An unexpected error occurred during sign-in: $e';
//             });
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = e.message;
//           });
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _isLoading = false;
//             _isCodeSent = true;
//             _verificationId = verificationId;
//             _resendToken = resendToken;
//             _errorMessage = 'SMS code sent to $phoneNumberToVerify';
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _isLoading = false;
//             _verificationId = verificationId;
//             _errorMessage =
//                 'SMS code auto-retrieval timed out. Please enter manually.';
//           });
//         },
//         timeout: const Duration(seconds: 60),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.message;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred: $e';
//       });
//     }
//   }

//   void _signInWithPhoneNumber() async {
//     if (_smsCodeController.text.isEmpty || _verificationId == null) {
//       setState(() {
//         _errorMessage = 'Please enter the SMS code.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: _smsCodeController.text.trim(),
//       );

//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       if (userCredential.user != null) {
//         await _syncUserWithSupabase(userCredential.user!.uid);
//         if (mounted) {
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.message;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred: $e';
//       });
//     }
//   }

//   Future<void> _syncUserWithSupabase(String firebaseUid) async {
//     try {
//       final response = await supabase
//           .from('users')
//           .select('id')
//           .eq('id', firebaseUid)
//           .single()
//           .limit(1);

//       if (response.data == null) {
//         final insertResponse = await supabase.from('users').insert({
//           'id': firebaseUid,
//         });

//         if (insertResponse.error != null) {
//           // Handle specific insert error
//           print(
//               'Supabase INSERT error syncing user: ${insertResponse.error!.message}');
//           setState(() {
//             _errorMessage = 'Failed to create user profile. Please try again.';
//           });
//           // Don't re-throw here if you've already handled the UI update.
//           // If you want it to propagate to the calling sign-in logic, then re-throw.
//           // For now, logging and setting error message might be sufficient for this context.
//           return; // Exit function on insert error
//         }
//         print('New user record inserted in Supabase for UID: $firebaseUid');
//       } else {
//         print('User record already exists in Supabase for UID: $firebaseUid');
//       }
//     } on PostgrestException catch (e) {
//       print('Supabase SELECT error syncing user: ${e.message}');
//       setState(() {
//         _errorMessage = 'Failed to retrieve user profile. Please try again.';
//       });
//     } catch (e) {
//       print('General error syncing user with Supabase: $e');
//       setState(() {
//         _errorMessage = 'An unexpected error occurred during user data sync.';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     'assets/images/mghospital-logo.png',
//                     height: 60,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Welcome to MG Hospital',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF13a8b4),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 if (_errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Text(
//                       _errorMessage!,
//                       style: const TextStyle(color: Colors.red, fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 Row(
//                   children: [
//                     DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: _selectedCountryCode,
//                         icon: const Icon(Icons.arrow_drop_down),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedCountryCode = newValue!;
//                           });
//                         },
//                         items: <String>['+1', '+91']
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     // Phone Number Input
//                     Expanded(
//                       child: TextFormField(
//                         controller: _phoneNumberController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           hintText: 'e.g., 9132636351',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your phone number';
//                           }
//                           if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                             return 'Please enter digits only';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _verifyPhoneNumber,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF13a8b4),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isLoading && !_isCodeSent
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text(
//                           'Send Verification Code',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (_isCodeSent) ...[
//                   TextFormField(
//                     controller: _smsCodeController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'SMS Verification Code',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the SMS code';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _signInWithPhoneNumber,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[700],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: _isLoading && _isCodeSent
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : const Text(
//                             'Verify Code and Login',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

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
              await _syncUserWithSupabase(userCredential.user!.uid);
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
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
        await _syncUserWithSupabase(userCredential.user!.uid);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
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
        // User does not exist, insert new user
        final insertResponse =
            await supabase.from('users').insert({'id': firebaseUid}).execute();

        // Check for error using status (201 = created, 200 = success)
        if (insertResponse.status != 201 && insertResponse.status != 200) {
          setState(() {
            _errorMessage =
                'Failed to create user profile: ${insertResponse.status}';
          });
        }
      } else {
        // User exists, do nothing or log if needed
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during user sync: $e';
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
