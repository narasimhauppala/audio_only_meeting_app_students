class User {
  final String id;
  final String username;
  final String role;
  final bool isActive;
  final String token;  // Added token field

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.isActive,
    required this.token,  // Added to constructor
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      role: json['role'],
      isActive: true,
      token: json['token'],  // Parse token from response
    );
  }

  bool get isStudent => role == 'student';
}