import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';

import '../../app_entry.dart';
import '../../core/onboarding/onboarding_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  void _finish() async {
    await onboardingService.markCompleted();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AppEntry(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardSlide(
                    title: 'Secure by design',
                    description:
                        'Passave encrypts your passwords on your device.\nYou control the keys.',
                  ),
                  _OnboardSlide(
                    title: 'Local-first, cloud optional',
                    description:
                        'Your vault works fully offline.\nEncrypted cloud sync can be enabled later.',
                  ),
                  _OnboardSlide(
                    title: 'Security has trade-offs',
                    description:
                        'Forget your master password and recovery key,\nand your data cannot be recovered.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: PassaveButton(
                  isPrimary: false,
                  onPressed: _index == 2
                      ? _finish
                      : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ),
                  text: _index == 2 ? 'Get Started' : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide extends StatelessWidget {
  final String title;
  final String description;

  const _OnboardSlide({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
