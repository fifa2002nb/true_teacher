import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_role.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  bool _isLoading = false;
  User? _user;
  UserModel? _userModel;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  User? get user => _user;
  UserModel? get userModel => _userModel;
  UserRole? get userRole => _userModel?.role;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = _authService.currentUser;
      if (_user != null) {
        _userModel = await _userService.getUser(_user!.uid);
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      _user = userCredential.user;
      if (_user != null) {
        _userModel = await _userService.getUser(_user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      if (_user != null) {
        _userModel = await _userService.getUser(_user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithGoogle();
      _user = userCredential.user;
      if (_user != null) {
        _userModel = await _userService.getUser(_user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _userModel = null;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
