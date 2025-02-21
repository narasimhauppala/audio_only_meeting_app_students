import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/api_response.dart';
import '../../domain/models/meeting.dart';
import '../../domain/repositories/meetings_repository.dart';

class MeetingsRepositoryImpl implements MeetingsRepository {
  final Dio _dio;

  MeetingsRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<List<Meeting>>> getStudentMeetings() async {
    try {
      final response = await _dio.get(AppConstants.meetingsEndpoint);
      print('Meetings Response: ${response.data}'); // Debug log

      if (response.statusCode == 200) {
        try {
          final List<dynamic> meetingsJson = response.data['data']['meetings'] as List;
          final List<Meeting> meetings = meetingsJson
              .map((meeting) => Meeting.fromJson(meeting))
              .toList();
          return ApiResponse.success(meetings);
        } catch (e) {
          print('Parse error: $e'); // Debug log
          return ApiResponse.error('Failed to parse meetings data');
        }
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get meetings');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}'); // Debug log
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<void>> joinMeeting(String meetingId) async {
    try {
      final response = await _dio.post('/meetings/$meetingId/join');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to join meeting');
      }
    } on DioException catch (e) {
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<void>> leaveMeeting(String meetingId) async {
    try {
      final response = await _dio.post('/meetings/$meetingId/leave');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to leave meeting');
      }
    } on DioException catch (e) {
      return ApiResponse.error(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }
} 