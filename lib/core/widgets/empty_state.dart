import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? action;
  final String? actionLabel;

  const EmptyState({
    Key? key,
    required this.title,
    required this.subtitle,
    this.action,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.heading2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.bodySecondary, textAlign: TextAlign.center),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: action, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
