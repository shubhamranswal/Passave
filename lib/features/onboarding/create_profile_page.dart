import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/onboarding/onboarding_service.dart';
import '../../core/user/avatar_registry.dart';
import '../../core/utils/widgets/avatar_picker.dart';
import '../../core/utils/widgets/passave_button.dart';
import '../../core/utils/widgets/passave_scaffold.dart';
import '../../core/utils/widgets/passave_textfield.dart';
import '../auth/create_vault_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedAvatar;
  
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

    onboardingSession.avatarId =
        _selectedAvatar ?? AvatarRegistry.defaultAvatar();

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
              const Text(
                'Choose an avatar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              AvatarPicker(
                selectedAvatarId:
                    _selectedAvatar ?? AvatarRegistry.defaultAvatar(),
                onSelected: (id) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedAvatar = id;
                  });
                },
              ),
              const SizedBox(height: 32),
              PassaveTextField(
                controller: _nameController,
                hint: 'Your name',
                icon: const Icon(Icons.person_outline),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              PassaveTextField(
                controller: _emailController,
                hint: 'Email',
                icon: const Icon(Icons.email_outlined),
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
