class User {
  final String id;
  final String username;
  final String role;
  final bool isActive;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.isActive,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle the nested data structure from your API
    final userData = json['data'] ?? json;
    
    return User(
      id: userData['_id'] ?? '',
      username: userData['username'] ?? '',
      role: userData['role'] ?? 'student',
      isActive: userData['isActive'] ?? true,
      token: userData['token'] ?? json['token'] ?? '',  // Handle both nested and direct token
    );
  }

  bool get isStudent => role == 'student';
  bool get isHost => role == 'host';
}