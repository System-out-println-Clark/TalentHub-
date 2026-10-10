import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SocialLinksRow extends StatelessWidget {
  final String? instagram;
  final String? tiktok;
  final String? youtube;

  const SocialLinksRow({
    Key? key,
    this.instagram,
    this.tiktok,
    this.youtube,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (instagram != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram),
            color: AppColors.gold,
            onPressed: () => _launchUrl(instagram!),
          ),
        if (tiktok != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.tiktok),
            color: AppColors.gold,
            onPressed: () => _launchUrl(tiktok!),
          ),
        if (youtube != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.youtube),
            color: AppColors.gold,
            onPressed: () => _launchUrl(youtube!),
          ),
      ],
    );
  }

  void _launchUrl(String url) async {
    // Placeholder – implementation will use url_launcher later.
  }
}
