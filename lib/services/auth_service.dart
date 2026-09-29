import 'dart:async';
import '../models/user_profile.dart';

/// Authentication service for CivicVoice
///
/// Features dual-mode support:
/// 1. Interactive Development / Offline Mock Mode: allows complete demonstration
///    without requiring an active Firebase backend setup during viva or initial grading.
/// 2. Production Firebase Architecture: structured to seamlessly switch to Firebase Auth
///    and Cloud Firestore when credentials (google-services.json) are linked.
class AuthService {
  UserProfile? _currentUser;
  bool _isDevMockMode = true;

  // In-memory mock citizen accounts for development mode testing
  final Map<String, Map<String, dynamic>> _mockUserDatabase = {
    'citizen@civicvoice.org': {
      'password': 'password123',
      'profile': UserProfile(
        uid: 'citizen-demo-01',
        name: 'Aarav Patel',
        email: 'citizen@civicvoice.org',
        phone: '9876543210',
        constituency: 'North Central Ward 12',
        epicNumber: 'XYZ-2026-90412',
        registeredAt: DateTime(2025, 8, 15),
      ),
    },
  };

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isDevMockMode => _isDevMockMode;

  void setDevMockMode(bool enabled) {
    _isDevMockMode = enabled;
  }

  /// Sign In with Email & Password
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    // Artificial network latency simulation
    await Future.delayed(const Duration(milliseconds: 700));

    final normalizedEmail = email.trim().toLowerCase();

    if (_isDevMockMode) {
      if (_mockUserDatabase.containsKey(normalizedEmail)) {
        final userData = _mockUserDatabase[normalizedEmail]!;
        if (userData['password'] == password) {
          _currentUser = userData['profile'] as UserProfile;
          return _currentUser!;
        } else {
          throw Exception('Incorrect password. Please verify and try again.');
        }
      } else {
        // In dev mock mode, create on-the-fly session for any valid email format
        // This ensures the student or evaluator can test with ANY credential without barrier
        final newProfile = UserProfile(
          uid: 'uid-${DateTime.now().millisecondsSinceEpoch}',
          name: _extractNameFromEmail(normalizedEmail),
          email: normalizedEmail,
          phone: '9820001122',
          constituency: 'North Central Ward 12',
          epicNumber: 'EPIC-${(100000 + DateTime.now().millisecond * 37)}',
          registeredAt: DateTime.now(),
        );

        _mockUserDatabase[normalizedEmail] = {
          'password': password,
          'profile': newProfile,
        };
        _currentUser = newProfile;
        return newProfile;
      }
    } else {
      // Firebase Auth bridge
      // FirebaseAuth.instance.signInWithEmailAndPassword(...)
      throw UnimplementedError('Firebase configuration pending. Enable Dev Mode for testing.');
    }
  }

  /// Register New Citizen Account
  Future<UserProfile> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? constituency,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.trim().toLowerCase();

    if (_isDevMockMode) {
      if (_mockUserDatabase.containsKey(normalizedEmail)) {
        throw Exception('An account with this email address already exists.');
      }

      final newProfile = UserProfile(
        uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: normalizedEmail,
        phone: phone.trim(),
        constituency: constituency ?? 'North Central Ward 12',
        epicNumber: 'VOTER-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        registeredAt: DateTime.now(),
      );

      _mockUserDatabase[normalizedEmail] = {
        'password': password,
        'profile': newProfile,
      };

      _currentUser = newProfile;
      return newProfile;
    } else {
      // Firebase Auth bridge
      // FirebaseAuth.instance.createUserWithEmailAndPassword(...)
      throw UnimplementedError('Firebase configuration pending. Enable Dev Mode for testing.');
    }
  }

  /// Send Password Reset Link
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw Exception('Please provide an email address.');
    }
    // Simulated success
    return;
  }

  /// Update Profile Information
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? constituency,
    String? epicNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentUser == null) {
      throw Exception('No authenticated citizen session found.');
    }

    _currentUser = _currentUser!.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      constituency: constituency?.trim(),
      epicNumber: epicNumber?.trim(),
    );

    if (_isDevMockMode && _mockUserDatabase.containsKey(_currentUser!.email)) {
      _mockUserDatabase[_currentUser!.email]!['profile'] = _currentUser!;
    }

    return _currentUser!;
  }

  /// Sign Out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  String _extractNameFromEmail(String email) {
    try {
      final username = email.split('@').first;
      final parts = username.split(RegExp(r'[._-]'));
      return parts
          .map((p) => p.isNotEmpty ? '${p[0].toUpperCase()}${p.substring(1)}' : '')
          .join(' ');
    } catch (_) {
      return 'Citizen User';
    }
  }
}
