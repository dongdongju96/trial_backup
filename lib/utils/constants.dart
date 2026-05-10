import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const Duration splashDuration = Duration(milliseconds: 1200);
  static const bool showDebugCameraPreview = false;
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF070712);
  static const Color surface = Color(0xFF111326);
  static const Color surfaceLight = Color(0xFF1A1D35);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color pinkAccent = Color(0xFFEC4899);
  static const Color cyanAccent = Color(0xFF22D3EE);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8D1);
  static const Color danger = Color(0xFFFF4D6D);
  static const Color success = Color(0xFF34D399);
  static const Color mask = Color(0xFF000000);
  static const Color placeholderMaleHair = Color(0xFF202633);
  static const Color placeholderFemaleHair = Color(0xFF4A2637);
  static const Color placeholderMaleSkin = Color(0xFFC99371);
  static const Color placeholderFemaleSkin = Color(0xFFD8A17E);
  static const Color placeholderMouth = Color(0xFF7A4B3A);
  static const Color portraitMaleGradientEnd = Color(0xFF172C55);
  static const Color portraitFemaleGradientEnd = Color(0xFF3A184A);
  static const Color cyanGlowShadow = Color(0x4422D3EE);

  // Backward-compatible names while the app moves toward AppColors.
  static const Color backgroundColor = background;
  static const Color surfaceColor = surface;
  static const Color accentColor = cyanAccent;
  static const Color warningColor = pinkAccent;
}

class AppSpacing {
  const AppSpacing._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double screenPadding = 24;
  static const double gamePadding = 20;
}

class AppRadii {
  const AppRadii._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 24;
  static const double round = 999;
}

class AppGradients {
  const AppGradients._();

  static const LinearGradient button = LinearGradient(
    colors: [
      AppColors.primaryPurple,
      AppColors.primaryBlue,
      AppColors.cyanAccent,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient surface = LinearGradient(
    colors: [AppColors.surfaceLight, AppColors.surface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient portraitMale = LinearGradient(
    colors: [AppColors.surface, AppColors.portraitMaleGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient portraitFemale = LinearGradient(
    colors: [AppColors.surface, AppColors.portraitFemaleGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> neonGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.42),
        blurRadius: 24,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.18),
        blurRadius: 48,
        spreadRadius: 3,
      ),
    ];
  }

  static const List<BoxShadow> cardGlow = [
    BoxShadow(
      color: AppColors.cyanGlowShadow,
      blurRadius: 28,
      spreadRadius: 1,
      offset: Offset(0, 10),
    ),
  ];
}

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle heroTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    height: 1.05,
  );

  static const TextStyle splashTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const TextStyle resultTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    height: 1.45,
  );

  static const TextStyle smallBody = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
  );

  static const TextStyle timer = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const TextStyle countdown = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 72,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const TextStyle modeLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.dark,
        surface: AppColors.surface,
        primary: AppColors.primaryPurple,
        secondary: AppColors.cyanAccent,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.cyanAccent),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.cyanAccent,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimary,
        iconColor: AppColors.cyanAccent,
      ),
      useMaterial3: true,
    );
  }
}
