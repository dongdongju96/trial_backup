import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_result.dart';
import '../utils/constants.dart';
import '../widgets/neon_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'game_screen.dart';
import 'mode_selection_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.result, super.key});

  static const String routeName = '/result';

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final rank = _focusRank(localizations, result.duration);

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
                        radius: 1.2,
                        colors: [
                          AppColors.pinkAccent.withValues(alpha: 0.18),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.neonGlow(
                              AppColors.pinkAccent,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 42,
                            backgroundColor: AppColors.surfaceLight,
                            child: Icon(
                              Icons.flash_on_rounded,
                              size: 52,
                              color: AppColors.pinkAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          localizations.gameOver,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.resultTitle.copyWith(
                            color: AppColors.pinkAccent,
                            shadows: AppShadows.neonGlow(AppColors.pinkAccent),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        NeonCard(
                          glowColor: AppColors.primaryPurple,
                          child: Column(
                            children: [
                              Text(
                                localizations.newRecord,
                                style: AppTextStyles.smallBody.copyWith(
                                  color: AppColors.cyanAccent,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                localizations.resultDurationIntro,
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                localizations.resultDurationSeconds(
                                  result.formattedSeconds,
                                ),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.resultTitle.copyWith(
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.lg,
                                  ),
                                  border: Border.all(
                                    color: AppColors.cyanAccent.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.military_tech_outlined,
                                        color: AppColors.cyanAccent,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          localizations.focusRank,
                                          style: AppTextStyles.smallBody,
                                        ),
                                      ),
                                      Text(
                                        rank,
                                        style: AppTextStyles.modeLabel.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        PrimaryButton(
                          label: localizations.retry,
                          icon: Icons.refresh,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              GameScreen.routeName,
                              arguments: result.mode,
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SecondaryButton(
                          label: localizations.shareResultTodo,
                          icon: Icons.ios_share_outlined,
                          onPressed: null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SecondaryButton(
                          label: localizations.backToModeSelection,
                          icon: Icons.grid_view_rounded,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              ModeSelectionScreen.routeName,
                              (route) => false,
                            );
                          },
                        ),
                        const Spacer(),
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

  String _focusRank(AppLocalizations localizations, Duration duration) {
    final seconds = duration.inMilliseconds / 1000;
    if (seconds < 3) {
      return localizations.rankDistracted;
    }
    if (seconds < 7) {
      return localizations.rankRookieFocus;
    }
    if (seconds < 15) {
      return localizations.rankSteadyEyes;
    }
    if (seconds < 30) {
      return localizations.rankSteelEyes;
    }
    return localizations.rankEyeLockMaster;
  }
}
