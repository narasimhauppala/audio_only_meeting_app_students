import '../../core/utils/api_response.dart';
import '../models/meeting.dart';

abstract class MeetingsRepository {
  Future<ApiResponse<List<Meeting>>> getStudentMeetings();
  Future<ApiResponse<void>> joinMeeting(String meetingId);
  Future<ApiResponse<void>> leaveMeeting(String meetingId);
} 