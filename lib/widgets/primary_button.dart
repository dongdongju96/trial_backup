import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Full width is the default because mobile game actions should be easy to tap.
  final bool isFullWidth;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    final button = AnimatedScale(
      duration: const Duration(milliseconds: 90),
      scale: _isPressed && isEnabled ? 0.97 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled ? AppGradients.button : AppGradients.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: isEnabled
              ? AppShadows.neonGlow(AppColors.primaryPurple)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            onTap: widget.onPressed,
            onHighlightChanged: (value) {
              setState(() {
                _isPressed = value;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.isFullWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: AppColors.textPrimary),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      height: 54,
      child: button,
    );
  }
}
