import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';

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

  Future<void> _finish() async {
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
    return PassaveScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardSlide(
                    asset: 'assets/images/onboarding/onboarding_1.png',
                    title: 'Secure by design',
                    description:
                        'Passave encrypts your passwords on your device.\nYou control the keys.',
                  ),
                  _OnboardSlide(
                    asset: 'assets/images/onboarding/onboarding_2.png',
                    title: 'Local-first, cloud optional',
                    description:
                        'Your vault works fully offline.\nEncrypted cloud sync can be enabled later.',
                  ),
                  _OnboardSlide(
                    asset: 'assets/images/onboarding/onboarding_3.png',
                    title: 'Security has trade-offs',
                    description:
                        'Forget your master password and recovery key,\nand your data cannot be recovered.',
                  ),
                ],
              ),
            ),
            _PageIndicators(currentIndex: _index, count: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: SizedBox(
                width: double.infinity / 4,
                height: 52,
                child: PassaveButton(
                  isPrimary: _index == 2,
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
  final String asset;
  final String title;
  final String description;

  const _OnboardSlide({
    required this.asset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isSmall = height < 700;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isSmall ? 16 : 32,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Column(
          key: ValueKey(asset),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: isSmall ? 4 : 5,
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.85,
              ),
            ),
            SizedBox(height: isSmall ? 16 : 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int currentIndex;
  final int count;

  const _PageIndicators({
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: currentIndex == i ? 20 : 8,
            decoration: BoxDecoration(
              color: currentIndex == i
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
