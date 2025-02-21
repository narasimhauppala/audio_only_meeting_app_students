import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/api_response.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../local/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required Dio dio,
    required SecureStorage secureStorage,
  })  : _dio = dio,
        _secureStorage = secureStorage;

  @override
  Future<ApiResponse<User>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        try {
          final user = User.fromJson(response.data);
          
          // Store all necessary user data
          await _secureStorage.write('token', user.token);
          await _secureStorage.write('user_id', user.id);
          await _secureStorage.write('username', user.username);
          await _secureStorage.write('role', user.role);
          
          return ApiResponse.success(user);
        } catch (parseError) {
          print('Parse error: $parseError');
          return ApiResponse.error('Failed to parse response data');
        }
      } else {
        return ApiResponse.error('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error('Invalid username or password');
      }
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      await _secureStorage.deleteAll();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to logout');
    }
  }

  @override
  Future<ApiResponse<User>> getStudentInfo() async {
    try {
      final response = await _dio.get(AppConstants.studentInfoEndpoint);
      
      if (response.statusCode == 200) {
        final userData = response.data['data']['student'];
        final user = User.fromJson(userData);
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get info');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ApiResponse.error('Student not found');
      }
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dio.put(
        AppConstants.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to change password');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error('Current password is incorrect');
      }
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read('token');
    return token != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await _secureStorage.read('token');
      if (token == null) return null;

      // Instead of making another API call, reconstruct the user from stored data
      final userId = await _secureStorage.read('user_id');
      final username = await _secureStorage.read('username');
      final role = await _secureStorage.read('role');

      if (userId != null && username != null) {
        return User(
          id: userId,
          username: username,
          role: role ?? 'student',
          isActive: true,
          token: token,
        );
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
} 