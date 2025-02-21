import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meetings_provider.dart';
import '../../domain/models/meeting.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch meetings when page loads
    Future.microtask(
      () => context.read<MeetingsProvider>().fetchMeetings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingsProvider>(
      builder: (context, meetingsProvider, child) {
        if (meetingsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (meetingsProvider.error != null) {
          return Center(child: Text(meetingsProvider.error!));
        }

        return RefreshIndicator(
          onRefresh: () => meetingsProvider.fetchMeetings(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (meetingsProvider.activeMeetings.isNotEmpty) ...[
                const Text(
                  'Current Meetings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...meetingsProvider.activeMeetings
                    .map((meeting) => MeetingCard(
                          meeting: meeting,
                          isActive: true,
                        )),
                const SizedBox(height: 24),
              ],
              if (meetingsProvider.upcomingMeetings.isNotEmpty) ...[
                const Text(
                  'Upcoming Meetings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...meetingsProvider.upcomingMeetings
                    .map((meeting) => MeetingCard(
                          meeting: meeting,
                          isActive: false,
                        )),
              ],
              if (meetingsProvider.meetings.isEmpty)
                const Center(
                  child: Text('No meetings available'),
                ),
            ],
          ),
        );
      },
    );
  }
}

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final bool isActive;

  const MeetingCard({
    required this.meeting,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(meeting.topic),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${meeting.status}',
              style: TextStyle(
                color: isActive ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (meeting.startTime != null)
              Text(
                'Time: ${meeting.startTime!.toLocal().toString().split('.')[0]}',
              ),
            Text('Participants: ${meeting.participants.length}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            final success = await context
                .read<MeetingsProvider>()
                .joinMeeting(meeting.id);
            
            if (success && context.mounted) {
              // Navigate to meeting room or show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Joined meeting successfully'),
                ),
              );
            }
          },
          child: Text(isActive ? 'Join Now' : 'Join When Active'),
        ),
      ),
    );
  }
} 