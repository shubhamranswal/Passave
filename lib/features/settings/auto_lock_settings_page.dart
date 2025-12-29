import 'package:flutter/material.dart';

import '../../core/security/auto_lock/auto_lock_preferences.dart';
import '../../core/security/auto_lock/auto_lock_service.dart';
import '../../core/security/auto_lock/auto_lock_timeout.dart';

class AutoLockSettingsPage extends StatefulWidget {
  const AutoLockSettingsPage({super.key});

  @override
  State<AutoLockSettingsPage> createState() => _AutoLockSettingsPageState();
}

class _AutoLockSettingsPageState extends State<AutoLockSettingsPage> {
  late AutoLockTimeout _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await autoLockPreferences.load();
    setState(() => _selected = value);
  }

  Future<void> _onChanged(AutoLockTimeout value) async {
    setState(() => _selected = value);
    await autoLockPreferences.save(value);
    await autoLockService.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-lock Timeout'),
      ),
      body: ListView(
        children: AutoLockTimeout.values.map((timeout) {
          return RadioListTile<AutoLockTimeout>(
            title: Text(timeout.label),
            value: timeout,
            groupValue: _selected,
            onChanged: (value) {
              if (value != null) _onChanged(value);
            },
            subtitle: timeout == AutoLockTimeout.never
                ? const Text(
                    'Not recommended. Vault will remain unlocked.',
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}
