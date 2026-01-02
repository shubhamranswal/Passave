import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';
import 'core/security/app_lifecycle_observer.dart';

final appLifecycleObserver = AppLifecycleObserver();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(appLifecycleObserver);
  await Hive.initFlutter();
  if (Platform.isAndroid) {
    await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
  }
  runApp(const PassaveApp());
}
