import 'package:flutter/material.dart';

import '../../../../core/user/user_profile.dart';
import '../../account/settings/edit_profile_page.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: userProfileService.load(),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        if (profile == null) return const SizedBox();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(
                        'assets/images/avatars/${profile.avatarId}.png')),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name ?? 'Your Vault',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (profile.email != null && profile.email!.isNotEmpty)
                        Text(
                          profile.email!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.edit),
              ],
            ),
          ),
        );
      },
    );
  }
}
