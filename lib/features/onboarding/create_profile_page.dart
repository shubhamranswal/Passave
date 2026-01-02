import 'package:flutter/material.dart';

import '../../core/utils/widgets/passave_button.dart';
import '../../core/utils/widgets/passave_scaffold.dart';
import '../../core/utils/widgets/passave_textfield.dart';
import '../../features/auth/create_vault_page.dart';
import 'onboarding_service.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedAvatar;

  static const _avatars = [
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    onboardingSession.name = _nameController.text.trim().isEmpty
        ? null
        : _nameController.text.trim();

    onboardingSession.email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();

    onboardingSession.avatarId = _selectedAvatar;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateVaultPage(),
      ),
    );
  }

  Future<void> _skip() async {
    onboardingSession.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateVaultPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a personal touch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This is optional. You can skip and add it later.',
              ),
              const SizedBox(height: 32),

              // Avatar picker
              const Text(
                'Choose an avatar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final id = _avatars[i];
                    final selected = id == _selectedAvatar;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = id;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/avatars/$id.png'),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Name
              PassaveTextField(
                controller: _nameController,
                hint: 'Your name',
                icon: Icon(Icons.person_outline),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Email
              PassaveTextField(
                controller: _emailController,
                hint: 'Email (optional)',
                icon: Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: PassaveButton(
                      isPrimary: false,
                      text: 'Skip',
                      onPressed: _skip,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PassaveButton(
                      text: 'Next',
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
