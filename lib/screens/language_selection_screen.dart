import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../controllers/locale_controller.dart';
import '../utils/constants.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({required this.localeController, super.key});

  static const String routeName = '/language-selection';

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final selectedLanguageCode =
        localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.languageSelectionTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.languageSelectionDescription,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              _LanguageTile(
                label: localizations.korean,
                locale: const Locale('ko'),
                isSelected: selectedLanguageCode == 'ko',
                onSelected: localeController.setLocale,
              ),
              const SizedBox(height: 12),
              _LanguageTile(
                label: localizations.english,
                locale: const Locale('en'),
                isSelected: selectedLanguageCode == 'en',
                onSelected: localeController.setLocale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.locale,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final Locale locale;
  final bool isSelected;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppConstants.accentColor : Colors.white24,
        ),
      ),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppConstants.accentColor)
          : null,
      onTap: () => onSelected(locale),
    );
  }
}
