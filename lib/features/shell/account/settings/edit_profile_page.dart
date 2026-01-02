import 'package:flutter/material.dart';
import 'package:passave/core/user/avatar_registry.dart';

import '../../../../core/user/user_profile.dart';
import '../../../../core/utils/widgets/avatar_picker.dart';
import '../../../../core/utils/widgets/passave_button.dart';
import '../../../../core/utils/widgets/passave_scaffold.dart';
import '../../../../core/utils/widgets/passave_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();

  String _avatarId = AvatarRegistry.defaultAvatar();
  DateTime _createdAt = DateTime.now();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await userProfileService.load();
    if (profile != null) {
      _name.text = profile.name ?? '';
      _email.text = profile.email ?? '';
      _avatarId = profile.avatarId;
      _createdAt = profile.createdAt;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    await userProfileService.save(
      UserProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        avatarId: _avatarId,
        createdAt: _createdAt,
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PassaveScaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage:
                          AssetImage('assets/images/avatars/$_avatarId.png'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AvatarPicker(
                    selectedAvatarId: _avatarId,
                    onSelected: (id) => setState(() => _avatarId = id),
                  ),
                  const SizedBox(height: 24),
                  PassaveTextField(
                    controller: _name,
                    hint: 'Your name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                  PassaveTextField(
                    controller: _email,
                    hint: 'Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null; // email is optional
                      }

                      final emailRegex = RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }

                      return null;
                    },
                    icon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          12 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PassaveButton(
          text: 'Save Profile',
          onPressed: _save,
        ),
      ),
    );
  }
}
