import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import 'firebase_service.dart';

/// Authentication service for CivicVoice
///
/// Fully integrated with Firebase Authentication and Cloud Firestore,
/// with dual-mode support:
/// 1. Firebase Authentication & Firestore (Live cloud backend: civicvoice-c476a)
/// 2. Offline / Demo Mock fallback for uninterrupted testing during vivas
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile? _currentUser;
  bool _isDevMockMode = false; // Live Firebase active by default!

  // In-memory mock citizen accounts for offline demo fallback
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

  AuthService() {
    _checkActiveFirebaseUser();
  }

  void setDevMockMode(bool enabled) {
    _isDevMockMode = enabled;
  }

  Future<void> _checkActiveFirebaseUser() async {
    if (!CivicFirebaseService.isInitialized) return;

    try {
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser != null) {
        final doc = await _firestore.collection(CivicFirebaseService.colUsers).doc(fbUser.uid).get();
        if (doc.exists && doc.data() != null) {
          _currentUser = UserProfile.fromMap(doc.data()!, id: fbUser.uid);
        } else {
          _currentUser = UserProfile(
            uid: fbUser.uid,
            name: fbUser.displayName ?? _extractNameFromEmail(fbUser.email ?? 'citizen@example.org'),
            email: fbUser.email ?? '',
            phone: fbUser.phoneNumber ?? '9876543210',
            constituency: 'North Central Ward 12',
            epicNumber: 'EPIC-${fbUser.uid.substring(0, 6).toUpperCase()}',
            registeredAt: DateTime.now(),
          );
        }
      }
    } catch (_) {
      // Ignore background session restoration errors
    }
  }

  /// Sign In with Email & Password (via Firebase Auth)
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    // 1. Try Firebase Authentication first if available
    if (CivicFirebaseService.isInitialized && !_isDevMockMode) {
      try {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: normalizedEmail,
          password: password,
        );

        final uid = credential.user!.uid;

        // Fetch citizen profile from Firestore
        final doc = await _firestore.collection(CivicFirebaseService.colUsers).doc(uid).get();
        if (doc.exists && doc.data() != null) {
          _currentUser = UserProfile.fromMap(doc.data()!, id: uid);
        } else {
          // If Firestore profile doesn't exist yet, create baseline document
          _currentUser = UserProfile(
            uid: uid,
            name: credential.user!.displayName ?? _extractNameFromEmail(normalizedEmail),
            email: normalizedEmail,
            phone: credential.user!.phoneNumber ?? '9876543210',
            constituency: 'North Central Ward 12',
            epicNumber: 'EPIC-${uid.substring(0, 6).toUpperCase()}',
            registeredAt: DateTime.now(),
          );
          await _firestore.collection(CivicFirebaseService.colUsers).doc(uid).set(_currentUser!.toMap());
        }

        return _currentUser!;
      } on FirebaseAuthException catch (e) {
        // Human-friendly error translation
        if (e.code == 'user-not-found') {
          throw Exception('No registered citizen account found with this email.');
        } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          throw Exception('Incorrect password. Please verify your credentials.');
        } else if (e.code == 'invalid-email') {
          throw Exception('The email address format is not valid.');
        } else if (e.code == 'user-disabled') {
          throw Exception('This citizen account has been deactivated.');
        } else {
          // If offline or network issue and demo email used, fallback gracefully
          if (_mockUserDatabase.containsKey(normalizedEmail) &&
              _mockUserDatabase[normalizedEmail]!['password'] == password) {
            _currentUser = _mockUserDatabase[normalizedEmail]!['profile'] as UserProfile;
            return _currentUser!;
          }
          throw Exception(e.message ?? 'Authentication failed. Please try again.');
        }
      } catch (e) {
        // Fallback for demo mock account during network outages
        if (_mockUserDatabase.containsKey(normalizedEmail) &&
            _mockUserDatabase[normalizedEmail]!['password'] == password) {
          _currentUser = _mockUserDatabase[normalizedEmail]!['profile'] as UserProfile;
          return _currentUser!;
        }
        throw Exception(e.toString().replaceAll('Exception: ', ''));
      }
    }

    // 2. Offline / Dev Mock Mode
    if (_mockUserDatabase.containsKey(normalizedEmail)) {
      final userData = _mockUserDatabase[normalizedEmail]!;
      if (userData['password'] == password) {
        _currentUser = userData['profile'] as UserProfile;
        return _currentUser!;
      } else {
        throw Exception('Incorrect password. Please verify and try again.');
      }
    } else {
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
  }

  /// Register New Citizen Account (via Firebase Auth + Firestore)
  Future<UserProfile> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? constituency,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (CivicFirebaseService.isInitialized && !_isDevMockMode) {
      try {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: normalizedEmail,
          password: password,
        );

        final uid = credential.user!.uid;

        // Update Firebase display name
        await credential.user!.updateDisplayName(name.trim());

        final newProfile = UserProfile(
          uid: uid,
          name: name.trim(),
          email: normalizedEmail,
          phone: phone.trim(),
          constituency: constituency ?? 'North Central Ward 12',
          epicNumber: 'EPIC-${uid.substring(0, 6).toUpperCase()}',
          registeredAt: DateTime.now(),
        );

        // Save citizen profile in Firestore
        await _firestore.collection(CivicFirebaseService.colUsers).doc(uid).set(newProfile.toMap());

        _currentUser = newProfile;
        return newProfile;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw Exception('An account with this email address already exists.');
        } else if (e.code == 'weak-password') {
          throw Exception('Password is too weak. Please use at least 6 characters.');
        } else if (e.code == 'invalid-email') {
          throw Exception('Please enter a valid email address.');
        } else {
          throw Exception(e.message ?? 'Registration failed. Please try again.');
        }
      } catch (e) {
        throw Exception(e.toString().replaceAll('Exception: ', ''));
      }
    }

    // Offline / Dev Mock Mode
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
  }

  /// Send Password Reset Link
  Future<void> sendPasswordReset(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw Exception('Please provide an email address.');
    }

    if (CivicFirebaseService.isInitialized && !_isDevMockMode) {
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: normalizedEmail);
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw Exception('No account found with this email.');
        }
        throw Exception(e.message ?? 'Could not dispatch password reset link.');
      }
    }

    // Offline simulation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Update Profile Information in Firestore
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? constituency,
    String? epicNumber,
  }) async {
    if (_currentUser == null) {
      throw Exception('No authenticated citizen session found.');
    }

    final updated = _currentUser!.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      constituency: constituency?.trim(),
      epicNumber: epicNumber?.trim(),
    );

    if (CivicFirebaseService.isInitialized && !_isDevMockMode) {
      try {
        await _firestore.collection(CivicFirebaseService.colUsers).doc(updated.uid).update(updated.toMap());
      } catch (_) {
        // If Firestore update fails, continue with in-memory update
      }
    }

    _currentUser = updated;
    if (_mockUserDatabase.containsKey(updated.email)) {
      _mockUserDatabase[updated.email]!['profile'] = updated;
    }

    return updated;
  }

  /// Sign Out from Firebase
  Future<void> signOut() async {
    if (CivicFirebaseService.isInitialized) {
      try {
        await _firebaseAuth.signOut();
      } catch (_) {}
    }
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
