import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

class OutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool enabled;

  const OutlineButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.darkTheme.colorScheme.onPrimary,
        side: const BorderSide(color: AppColors.gold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(label),
    );
  }
}
