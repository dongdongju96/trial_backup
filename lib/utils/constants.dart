import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const Duration splashDuration = Duration(milliseconds: 1200);
  static const bool showDebugCameraPreview = false;
  static const bool useMockFaceTracking = bool.fromEnvironment('USE_MOCK_GAZE');
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFFFF8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF3EEFF);
  static const Color primaryPurple = Color(0xFFA98CF5);
  static const Color primaryBlue = Color(0xFF8EBBFF);
  static const Color pinkAccent = Color(0xFFFF9DB8);
  static const Color cyanAccent = Color(0xFF73D7D0);
  static const Color textPrimary = Color(0xFF352B48);
  static const Color textSecondary = Color(0xFF756A89);
  static const Color danger = Color(0xFFE56D93);
  static const Color success = Color(0xFF63BFA4);
  static const Color mask = Color(0xFF000000);
  static const Color placeholderMaleHair = Color(0xFF7586A7);
  static const Color placeholderFemaleHair = Color(0xFFC483A3);
  static const Color placeholderMaleSkin = Color(0xFFF1C3A8);
  static const Color placeholderFemaleSkin = Color(0xFFF4C8B3);
  static const Color placeholderMouth = Color(0xFFB56E8A);
  static const Color portraitMaleGradientEnd = Color(0xFFE6EEFF);
  static const Color portraitFemaleGradientEnd = Color(0xFFFFE0EC);
  static const Color softShadow = Color(0x1A5F4B8B);

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
  static const double gamePadding = 14;
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
    colors: [AppColors.primaryPurple, AppColors.primaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient surface = LinearGradient(
    colors: [AppColors.surface, AppColors.surface],
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

  static List<BoxShadow> softLift([Color color = AppColors.softShadow]) {
    return [
      BoxShadow(
        color: color,
        blurRadius: 18,
        spreadRadius: -8,
        offset: Offset(0, 12),
      ),
    ];
  }

  static const List<BoxShadow> cardGlow = [
    BoxShadow(
      color: AppColors.softShadow,
      blurRadius: 18,
      spreadRadius: -8,
      offset: Offset(0, 12),
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
    color: AppColors.surface,
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

  static ThemeData get cleanTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.light,
        surface: AppColors.surface,
        primary: AppColors.primaryPurple,
        secondary: AppColors.pinkAccent,
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

  static ThemeData get darkTheme => cleanTheme;
}
