import 'package:flutter/foundation.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/api_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(username, password);
      
      if (response.success && response.data != null) {
        _currentUser = response.data;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.error ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.changePassword(
        currentPassword,
        newPassword,
      );

      if (!response.success) {
        _error = response.error;
      }
    } catch (e) {
      _error = 'Failed to change password';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 