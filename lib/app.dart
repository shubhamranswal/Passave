import 'package:flutter/material.dart';
import 'package:passave/app_entry.dart';

class PassaveApp extends StatelessWidget {
  const PassaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Passave',
      debugShowCheckedModeBanner: false,
      home: AppEntry(),
    );
  }
}
