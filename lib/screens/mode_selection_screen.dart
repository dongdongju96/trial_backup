import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_mode.dart';
import '../utils/constants.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: localizations.language,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(LanguageSelectionScreen.routeName);
                  },
                  icon: const Icon(Icons.language),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.center_focus_strong_outlined,
                size: 52,
                color: AppConstants.accentColor,
              ),
              const SizedBox(height: 24),
              Text(
                localizations.chooseChallengeMode,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                localizations.modeSelectionDescription,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: localizations.maleMode,
                icon: Icons.person_outline,
                onPressed: () => _openPermission(context, GameMode.male),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: localizations.femaleMode,
                icon: Icons.person_2_outlined,
                onPressed: () => _openPermission(context, GameMode.female),
              ),
              const Spacer(flex: 2),
            ],
          ),
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
