import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_mode.dart';
import '../utils/constants.dart';
import '../widgets/neon_card.dart';
import '../widgets/primary_button.dart';
import 'language_selection_screen.dart';
import 'permission_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  static const String routeName = '/mode-selection';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.1,
                        colors: [
                          AppColors.primaryPurple.withValues(alpha: 0.18),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: AppShadows.neonGlow(
                                AppColors.cyanAccent,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 38,
                              backgroundColor: AppColors.surfaceLight,
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                size: 44,
                                color: AppColors.cyanAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          localizations.modeSelectionHeroTitleTop,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.resultTitle.copyWith(
                            fontSize: 42,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          localizations.modeSelectionHeroTitleBottom,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.resultTitle.copyWith(
                            fontSize: 42,
                            color: AppColors.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          localizations.modeSelectionSubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.pinkAccent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        NeonCard(
                          glowColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.center_focus_strong_outlined,
                                color: AppColors.cyanAccent,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  localizations.modeSelectionRule,
                                  style: AppTextStyles.smallBody,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        PrimaryButton(
                          label: localizations.maleMode,
                          icon: Icons.person_outline,
                          onPressed: () =>
                              _openPermission(context, GameMode.male),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrimaryButton(
                          label: localizations.femaleMode,
                          icon: Icons.person_2_outlined,
                          onPressed: () =>
                              _openPermission(context, GameMode.female),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _UtilityIcon(
                              icon: Icons.settings_outlined,
                              tooltip: localizations.settings,
                            ),
                            _UtilityIcon(
                              icon: Icons.help_outline,
                              tooltip: localizations.help,
                            ),
                            _UtilityIcon(
                              icon: Icons.language,
                              tooltip: localizations.language,
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(LanguageSelectionScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openPermission(BuildContext context, GameMode mode) {
    Navigator.of(
      context,
    ).pushNamed(PermissionScreen.routeName, arguments: mode);
  }
}

class _UtilityIcon extends StatelessWidget {
  const _UtilityIcon({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.round),
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.cyanAccent.withValues(alpha: 0.32),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(icon, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
