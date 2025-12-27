import 'package:flutter/material.dart';
import 'package:passave/app_entry.dart';

import 'core/onboarding/onboarding_service.dart';
import 'features/onboarding/onboarding_page.dart';

class PassaveApp extends StatelessWidget {
  const PassaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passave',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: onboardingService.isCompleted(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.data!) {
            return const OnboardingPage();
          }
          return const AppEntry();
        },
      ),
    );
  }
}
