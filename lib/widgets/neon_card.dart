import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NeonCard extends StatelessWidget {
  const NeonCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.glowColor = AppColors.cyanAccent,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: glowColor.withValues(alpha: 0.36)),
        boxShadow: AppShadows.neonGlow(glowColor),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
