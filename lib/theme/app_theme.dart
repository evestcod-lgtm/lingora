import 'package:flutter/material.dart';

/// Единая визуальная система Lingora: фиолетовый + бирюзовый,
/// мягкий "магический" стиль, стеклянные карточки, свечение.
class AppColors {
  static const Color violetDeep = Color(0xFF241645);
  static const Color violetPrimary = Color(0xFF6C4CE0);
  static const Color violetSoft = Color(0xFF9C7BFF);
  static const Color teal = Color(0xFF35E2C9);
  static const Color tealSoft = Color(0xFF7FF6E4);
  static const Color bgTop = Color(0xFF1B1035);
  static const Color bgBottom = Color(0xFF32215C);
  static const Color success = Color(0xFF3DDC97);
  static const Color error = Color(0xFFFF6E86);
  static const Color gold = Color(0xFFFFC65C);
  static const Color textPrimary = Color(0xFFF5F3FF);
  static const Color textSecondary = Color(0xFFC9BEEC);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgTop, bgBottom],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violetPrimary, teal],
  );

  static const LinearGradient goldButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD98C), gold],
  );
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgTop,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.violetPrimary,
        secondary: AppColors.teal,
        surface: AppColors.violetDeep,
      ),
      textTheme: base.textTheme
          .apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          )
          .copyWith(
            headlineLarge: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
            headlineMedium: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            titleMedium: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            bodyMedium: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
