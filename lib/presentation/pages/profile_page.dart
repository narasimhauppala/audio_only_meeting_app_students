import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(
        child: Text('No user data available'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const CircleAvatar(
          radius: 50,
          child: Icon(Icons.person, size: 50),
        ),
        const SizedBox(height: 16),
        Text(
          user.username,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Username'),
          subtitle: Text(user.username),
        ),
        ListTile(
          leading: const Icon(Icons.school),
          title: const Text('Role'),
          subtitle: const Text('Student'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement password change
          },
          child: const Text('Change Password'),
        ),
      ],
    );
  }
} 