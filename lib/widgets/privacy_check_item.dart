import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PrivacyCheckItem extends StatelessWidget {
  const PrivacyCheckItem({
    required this.text,
    this.icon = Icons.check_circle_outline,
    super.key,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.success, size: 22),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: AppTextStyles.smallBody)),
      ],
    );
  }
}
