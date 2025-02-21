class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.74:5000/api'
  );
  
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'ws://192.168.1.74:5002/ws'
  );

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String meetingsEndpoint = '/meetings';
  static const String profileEndpoint = '/profile';
  static const String recordingsEndpoint = '/recordings';
  static const String studentInfoEndpoint = '/student/info';
  static const String changePasswordEndpoint = '/student/change-password';

  // WebSocket Events
  static const String joinMeetingEvent = 'join-meeting';
  static const String leaveMeetingEvent = 'leave-meeting';
  static const String audioStreamEvent = 'audio-stream';
  static const String privateChatEvent = 'private-chat';
} 