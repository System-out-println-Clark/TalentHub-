import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isOnline;

  const Avatar({
    Key? key,
    required this.imageUrl,
    this.size = 48,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: AppColors.surfaceDarker,
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppColors.liveRed,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
