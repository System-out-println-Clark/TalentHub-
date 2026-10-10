import 'package:flutter/material.dart';
import 'package:talenthub/core/theme/app_colors.dart';
import 'package:talenthub/core/theme/app_text_styles.dart';
import 'package:talenthub/core/widgets/gold_button.dart';
import 'package:talenthub/core/widgets/outline_button.dart';
import 'package:talenthub/core/widgets/text_field.dart';
import 'package:talenthub/core/widgets/live_badge.dart';
import 'package:talenthub/core/widgets/empty_state.dart';

class DesignShowcase extends StatelessWidget {
  const DesignShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Palette', style: AppTextStyles.heading2),
            Row(
              children: const [
                _ColorBox(color: AppColors.background, label: 'Background'),
                _ColorBox(color: AppColors.surfaceDark, label: 'SurfaceDark'),
                _ColorBox(color: AppColors.surfaceDarker, label: 'SurfaceDarker'),
                _ColorBox(color: AppColors.gold, label: 'Gold'),
                _ColorBox(color: AppColors.goldLight, label: 'GoldLight'),
                _ColorBox(color: AppColors.cream, label: 'Cream'),
                _ColorBox(color: AppColors.error, label: 'Error'),
                _ColorBox(color: AppColors.liveRed, label: 'LiveRed'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Typography', style: AppTextStyles.heading2),
            Text('Playfair Heading 1', style: AppTextStyles.heading1),
            Text('Playfair Heading 2', style: AppTextStyles.heading2),
            Text('Inter Body', style: AppTextStyles.body),
            const SizedBox(height: 24),
            const Text('Widgets', style: AppTextStyles.heading2),
            GoldButton(onPressed: () {}, label: 'Gold Button'),
            const SizedBox(height: 8),
            OutlineButton(onPressed: () {}, label: 'Outline Button'),
            const SizedBox(height: 8),
            AppTextField(hintText: 'Hint', controller: TextEditingController()),
            const SizedBox(height: 8),
            LiveBadge(),
            const SizedBox(height: 8),
            EmptyState(title: 'Empty', subtitle: 'No data'),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;
  const _ColorBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 40, height: 40, color: color),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
