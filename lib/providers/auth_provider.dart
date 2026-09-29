import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

/// Provider managing citizen authentication state, session, and profile edits
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDevMockMode => _authService.isDevMockMode;

  AuthProvider() {
    // Check initial user session if any
    _user = _authService.currentUser;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void toggleDevMode(bool enabled) {
    _authService.setDevMockMode(enabled);
    notifyListeners();
  }

  /// Sign In with Email & Password
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register New Citizen
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? constituency,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        constituency: constituency,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update Profile Details
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? constituency,
    String? epicNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.updateProfile(
        name: name,
        phone: phone,
        constituency: constituency,
        epicNumber: epicNumber,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send Password Reset Email
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordReset(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
