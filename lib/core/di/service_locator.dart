import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/local/secure_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../constants/app_constants.dart';
import '../../data/repositories/meetings_repository_impl.dart';
import '../../domain/repositories/meetings_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final Dio _dio;
  late final SecureStorage _secureStorage;
  late final AuthRepository _authRepository;
  late final MeetingsRepository _meetingsRepository;

  Future<void> initialize() async {
    // Initialize Dio
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Initialize Secure Storage
    _secureStorage = SecureStorage(
      storage: const FlutterSecureStorage(),
    );

    // Add Dio Interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle token expiration
          _secureStorage.deleteAll();
        }
        return handler.next(error);
      },
    ));

    // Initialize Repositories
    _authRepository = AuthRepositoryImpl(
      dio: _dio,
      secureStorage: _secureStorage,
    );

    _meetingsRepository = MeetingsRepositoryImpl(dio: _dio);
  }

  Dio get dio => _dio;
  SecureStorage get secureStorage => _secureStorage;
  AuthRepository get authRepository => _authRepository;
  MeetingsRepository get meetingsRepository => _meetingsRepository;
} 