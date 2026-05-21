import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CleanCard extends StatelessWidget {
  const CleanCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.accentColor = AppColors.primaryPurple,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: accentColor.withValues(alpha: 0.28)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
