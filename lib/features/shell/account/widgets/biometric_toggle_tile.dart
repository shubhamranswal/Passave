import 'package:flutter/material.dart';
import 'package:passave/features/shell/account/widgets/security_status_tile.dart';

import '../../../../core/security/biometric/biometric_service.dart';

class BiometricToggleTile extends StatefulWidget {
  const BiometricToggleTile({super.key});

  @override
  State<BiometricToggleTile> createState() => _BiometricToggleTileState();
}

class _BiometricToggleTileState extends State<BiometricToggleTile> {
  bool _supported = false;
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supported = await biometricService.isAvailable();
    final enabled = supported && await biometricService.isEnabled();

    if (!mounted) return;
    setState(() {
      _supported = supported;
      _enabled = enabled;
      _loading = false;
    });
  }

  Future<void> _toggle(bool value) async {
    if (value) {
      final ok = await biometricService.authenticate();
      if (!ok) return;

      await biometricService.enable();
    } else {
      final ok = await biometricService.authenticate();
      if (!ok) return;
      await biometricService.disable();
    }

    if (!mounted) return;
    setState(() => _enabled = value);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SecurityStatusTile(
        icon: Icons.fingerprint,
        title: 'Biometrics',
        status: 'Checking…',
        ok: false,
      );
    }

    if (!_supported) {
      return const SecurityStatusTile(
        icon: Icons.fingerprint,
        title: 'Biometrics',
        status: 'Not supported on this device',
        ok: false,
      );
    }

    return SecurityStatusTile(
      icon: Icons.fingerprint,
      title: 'Biometrics',
      status: _enabled ? 'Enabled on this device' : 'Disabled',
      ok: _enabled,
      trailing: Switch(
        value: _enabled,
        onChanged: _toggle,
      ),
    );
  }
}
