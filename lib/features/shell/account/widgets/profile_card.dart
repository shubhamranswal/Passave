import 'package:flutter/material.dart';
import 'package:passave/core/utils/customs/date_formatter.dart';

import '../../../../core/user/user_profile.dart';
import '../settings/edit_profile_page.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: userProfileService,
        builder: (_, __) {
          final profile = userProfileService.current;
          if (profile == null) return const SizedBox();

          final avatarId = profile.avatarId;
          final hasName = profile.name != null && profile.name!.isNotEmpty;
          final greeting = 'Hey, ${hasName ? profile.name! : 'there'}!';

          String joined =
              'Joined ${DateFormatter.monthYear(profile.createdAt)}';

          return GestureDetector(
            onTap: () async {
              await Navigator.push(
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
                      radius: 48,
                      backgroundImage: AssetImage(
                          'assets/images/avatars/${profile.avatarId}.png')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          joined +
                              (hasName
                                  ? ''
                                  : '\nTap to complete your profile!'),
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
        });
  }
}
