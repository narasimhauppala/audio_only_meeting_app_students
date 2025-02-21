import 'package:flutter/foundation.dart';
import '../../domain/models/meeting.dart';
import '../../domain/repositories/meetings_repository.dart';

class MeetingsProvider extends ChangeNotifier {
  final MeetingsRepository _meetingsRepository;
  
  List<Meeting> _meetings = [];
  bool _isLoading = false;
  String? _error;

  MeetingsProvider(this._meetingsRepository);

  List<Meeting> get meetings => _meetings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Meeting> get activeMeetings => 
      _meetings.where((m) => m.isActive).toList();
  
  List<Meeting> get upcomingMeetings => 
      _meetings.where((m) => m.isCreated).toList();

  Future<void> fetchMeetings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _meetingsRepository.getStudentMeetings();
      print('Meetings Provider Response: $response'); // Debug log
      
      if (response.success) {
        _meetings = response.data ?? [];
        print('Meetings count: ${_meetings.length}'); // Debug log
        _error = null;
      } else {
        _error = response.error;
        print('Error fetching meetings: ${response.error}'); // Debug log
      }
    } catch (e) {
      print('Exception in fetchMeetings: $e'); // Debug log
      _error = 'Failed to fetch meetings';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinMeeting(String meetingId) async {
    try {
      final response = await _meetingsRepository.joinMeeting(meetingId);
      if (response.success) {
        await fetchMeetings(); // Refresh meetings list
        return true;
      }
      _error = response.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to join meeting';
      notifyListeners();
      return false;
    }
  }
} 