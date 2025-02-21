import '../models/user.dart';
import '../../core/utils/api_response.dart';

abstract class AuthRepository {
  Future<ApiResponse<User>> login(String username, String password);
  Future<ApiResponse<void>> logout();
  Future<ApiResponse<User>> getStudentInfo();
  Future<ApiResponse<void>> changePassword(String currentPassword, String newPassword);
  Future<bool> isAuthenticated();
  Future<User?> getCurrentUser();
} 