import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter/foundation.dart';

class Profile {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final bool isAdmin;

  const Profile({
    this.name,
    this.dateOfBirth,
    this.gender,
    required this.isAdmin,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: _genderToString(json['gender']),
      isAdmin: json['is_admin'] ?? false,
    );
  }

  static String _genderToString(dynamic genderValue) {
    if (genderValue == null) return '';
    if (genderValue == 1) return 'Male';
    if (genderValue == 2) return 'Female';
    return genderValue.toString();
  }

  Profile copyWith({
    String? name,
    String? dateOfBirth,
    String? gender,
    bool? isAdmin,
  }) {
    return Profile(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

class UserService extends ChangeNotifier {
  User? _firebaseUser;
  Profile? _profile;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;
  String? get userId => _firebaseUser?.uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  UserService() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadProfileData(user.uid);
      } else {
        _clearUserData();
      }
      notifyListeners();
    });
  }

  Future<void> _loadProfileData(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _supabase
          .from('users')
          .select('name, date_of_birth, gender, is_admin')
          .eq('id', userId)
          .single()
          .execute();

      if (response.status == 200 && response.data != null) {
        _profile = Profile.fromJson(response.data);
        debugPrint('[UserService] Profile loaded: ${_profile?.name}');
      } else {
        _setError('Failed to load profile data');
      }
    } catch (e) {
      debugPrint('[UserService] Error loading profile: $e');
      _setError('Error loading profile data');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> syncUserWithSupabase(String firebaseUid) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('id', firebaseUid)
          .limit(1)
          .execute();

      final List data = response.data as List;

      if (data.isEmpty) {
        final insertResponse =
            await _supabase.from('users').insert({'id': firebaseUid}).execute();

        if (insertResponse.status != 201 && insertResponse.status != 200) {
          throw Exception('Failed to create user profile');
        }
      }
    } catch (e) {
      debugPrint('[UserService] Error syncing user: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? dateOfBirth,
    String? gender,
  }) async {
    if (_firebaseUser == null) return;

    _setLoading(true);
    _clearError();

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth;
      if (gender != null) updates['gender'] = gender;

      final response = await _supabase
          .from('users')
          .update(updates)
          .eq('id', _firebaseUser!.uid)
          .execute();

      if (response.status == 200) {
        // Reload profile data to get updated values
        await _loadProfileData(_firebaseUser!.uid);
      } else {
        _setError('Failed to update profile');
      }
    } catch (e) {
      debugPrint('[UserService] Error updating profile: $e');
      _setError('Error updating profile');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _clearUserData();
      notifyListeners();
    } catch (e) {
      debugPrint('[UserService] Error signing out: $e');
      _setError('Error signing out');
    }
  }

  void _clearUserData() {
    _profile = null;
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
  }
}
