import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';
import 'core/security/app_lifecycle_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  await Hive.initFlutter();
  runApp(const PassaveApp());
}
