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
          print('Response data: ${response.data}'); // Debug log
          final user = User.fromJson(response.data);
          
          // Store token and user info
          await _secureStorage.write('token', user.token);
          await _secureStorage.write('user_id', user.id);
          
          return ApiResponse.success(user);
        } catch (parseError) {
          print('Parse error: $parseError'); // Debug log
          return ApiResponse.error('Failed to parse response data');
        }
      } else {
        print('Non-200 status code: ${response.statusCode}'); // Debug log
        return ApiResponse.error('Login failed');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}'); // Debug log
      print('Response: ${e.response?.data}'); // Debug log
      
      if (e.response?.statusCode == 401) {
        return ApiResponse.error('Invalid username or password');
      }
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
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
      
      if (response.data['status'] == 'success') {
        final user = User.fromJson(response.data['data']['student']);
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get info');
      }
    } on DioException catch (e) {
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

      if (response.data['status'] == 'success') {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
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
      final userId = await _secureStorage.read('user_id');
      if (userId == null) return null;

      final response = await _dio.get(AppConstants.studentInfoEndpoint);
      
      if (response.data['status'] == 'success') {
        return User.fromJson(response.data['data']['student']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 