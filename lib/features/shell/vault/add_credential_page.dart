import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passave/core/logo_suggestion/logo_suggestion.dart';
import 'package:passave/core/logo_suggestion/matcher.dart';
import 'package:passave/core/utils/widgets/logo_suggestion_tile.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/core/utils/widgets/security_level_form_field.dart';
import 'package:uuid/uuid.dart';

import '../../../core/security/password_strength/password_strength.dart';
import '../../../core/utils/theme/passave_theme.dart';
import '../../../core/utils/widgets/credential_logo.dart';
import '../../../core/utils/widgets/passave_textfield.dart';
import '../../../core/utils/widgets/password_field.dart';
import '../../../core/utils/widgets/section_title.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'repository/vault_provider.dart';

class AddCredentialPage extends StatefulWidget {
  final Credential? credential;

  const AddCredentialPage({
    super.key,
    this.credential,
  });

  bool get isEdit => credential != null;

  @override
  State<AddCredentialPage> createState() => _AddCredentialPageState();
}

class _AddCredentialPageState extends State<AddCredentialPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;

  String? _selectedDomain;
  List<LogoSuggestion> _suggestions = [];

  SecurityLevel? _securityLevel;
  bool _showNotes = false;
  bool _isSaving = false;
  bool _passwordChanged = false;

  final _uuid = const Uuid();
  final _passwordStrengthService = PasswordStrengthService();

  PasswordStrengthResult? _passwordStrength;
  Timer? _strengthDebounce;

  @override
  void initState() {
    super.initState();

    final c = widget.credential;

    _titleController = TextEditingController(text: c?.title ?? '');
    _usernameController = TextEditingController(text: c?.username ?? '');
    _passwordController = TextEditingController(text: c?.password ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');

    _securityLevel = c?.securityLevel;
    _showNotes = widget.isEdit && _notesController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _strengthDebounce?.cancel();
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) async {
    if (widget.isEdit &&
        !_passwordChanged &&
        value == widget.credential!.password) return;
    _passwordChanged = true;

    _strengthDebounce?.cancel();
    _strengthDebounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (!mounted || value.trim().isEmpty) {
          setState(() => _passwordStrength = null);
          return;
        }

        setState(
            () => _passwordStrength = _passwordStrengthService.analyze(value));
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final now = DateTime.now();

    String? site = _titleController.text.trim();
    site =
        _selectedDomain ?? (looksLikeDomain(site) ? extractDomain(site) : null);
    String title = _titleController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String? notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    if (widget.isEdit) {
      final updated = widget.credential!.copyWith(
        title: title,
        site: site,
        username: username,
        password: password,
        notes: notes,
        securityLevel: _securityLevel!,
        updatedAt: now,
      );
      await vaultRepository.update(updated);
    } else {
      final credential = Credential(
        id: _uuid.v4(),
        title: title,
        site: site,
        username: username,
        password: password,
        notes: notes,
        securityLevel: _securityLevel!,
        createdAt: now,
        updatedAt: now,
      );
      await vaultRepository.add(credential);
    }
    if (!mounted) return;
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(widget.isEdit ? 'Credential Updated' : 'Credential Added')),
    );
  }

  void _confirmDelete() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: PassaveTheme.danger,
                size: 36,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Credential?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: PassaveButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'Cancel',
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PassaveButton(
                      onPressed: () async {
                        await vaultRepository.delete(widget.credential!.id);
                        if (!mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Credential deleted.')),
                        );
                      },
                      text: 'Delete',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Credential' : 'Add Credential'),
        actions: widget.isEdit
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: PassaveTheme.danger,
                  ),
                  onPressed: _confirmDelete,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SectionTitle(title: 'Website or App'),
                const SizedBox(height: 8),
                PassaveTextField(
                  controller: _titleController,
                  hint: 'example.com',
                  icon: _selectedDomain == null
                      ? (widget.credential == null
                          ? Icon(
                              Icons.language,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: CredentialLogo(
                                  site: widget.credential!.site,
                                  fallbackText: _titleController.text.trim()),
                            ))
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: CredentialLogo(
                              site: _selectedDomain,
                              fallbackText: _titleController.text.trim()),
                        ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a website or app name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedDomain = null;
                      _suggestions = matchLogos(value).take(5).toList();
                    });
                  },
                ),
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ..._suggestions.map(
                    (s) => NameSuggestionTile(
                      service: s,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _titleController.text = s.name;
                          _selectedDomain = s.site;
                          _suggestions.clear();
                        });
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const SectionTitle(title: 'Username / Email'),
                const SizedBox(height: 8),
                PassaveTextField(
                  controller: _usernameController,
                  hint: 'username@example.com',
                  icon: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Password'),
                const SizedBox(height: 8),
                PasswordField(
                  controller: _passwordController,
                  hint: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onChanged: _onPasswordChanged,
                ),
                PasswordStrengthIndicator(
                  result: _passwordStrength,
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Security Level'),
                const SizedBox(height: 12),
                SecurityLevelFormField(
                    initialValue: _securityLevel,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a security level';
                      }
                      return null;
                    },
                    onChanged: (level) {
                      setState(() {
                        _securityLevel = level;
                      });
                    }),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    setState(() => _showNotes = !_showNotes);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle(title: 'Notes'),
                      Icon(
                        _showNotes ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _showNotes
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: PassaveTextField(
                            controller: _notesController,
                            hint: 'Additional info (2FA, recovery codes, etc.)',
                            icon: Icon(
                              Icons.notes_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: PassaveButton(
            loading: _isSaving,
            text: widget.isEdit ? 'Save Changes' : 'Save Credential',
            onPressed: _save,
          ),
        ),
      ),
    );
  }
}
