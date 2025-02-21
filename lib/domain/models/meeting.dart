class Meeting {
  final String id;
  final String topic;
  final String status;
  final DateTime? startTime;
  final List<String> participants;
  final List<String> activeParticipants;

  Meeting({
    required this.id,
    required this.topic,
    required this.status,
    this.startTime,
    required this.participants,
    required this.activeParticipants,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['_id'] ?? '',
      topic: json['topic'] ?? '',
      status: json['status'] ?? 'created',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      participants: (json['participants'] as List?)?.map((p) => p.toString()).toList() ?? [],
      activeParticipants: (json['participants'] as List?)?.map((p) => p.toString()).toList() ?? [],
    );
  }

  bool get isActive => status == 'active';
  bool get isCreated => status == 'created';
} 