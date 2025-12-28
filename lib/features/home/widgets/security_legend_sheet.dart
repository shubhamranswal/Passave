import 'package:flutter/material.dart';

class SecurityLegendSheet extends StatelessWidget {
  const SecurityLegendSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            'Security Levels',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _item(
            context,
            color: Colors.green,
            title: 'Low',
            description:
                'Non-critical credentials.\nExample: forums, throwaway accounts.',
          ),
          const SizedBox(height: 12),
          _item(
            context,
            color: Colors.orange,
            title: 'Medium',
            description:
                'Important but replaceable.\nExample: social media, shopping apps.',
          ),
          const SizedBox(height: 12),
          _item(
            context,
            color: Colors.red,
            title: 'High',
            description:
                'Highly sensitive information.\nExample: banking, primary email, work accounts.',
          ),
          const SizedBox(height: 24),
          Text(
            'Security levels help you organize and prioritize your vault. '
            'They do not change how encryption works.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
