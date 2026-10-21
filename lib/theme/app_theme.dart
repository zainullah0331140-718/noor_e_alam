import 'package:flutter/material.dart';

class AppTheme {
  static const Color patternGold = Color(0xFFD9B75B);
  static const Color patternEmerald = Color(0xFF1F8F4E);
  static const Color patternTeal = Color(0xFF1FB8B8);

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F8F4E),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF1F8F4E),
          secondary: const Color(0xFFD9B75B),
          tertiary: const Color(0xFFB8860B),
          surface: const Color(0xFFFBFBF7),
          surfaceContainerHighest: const Color(0xFFF5F3EE),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
      fontFamily: 'Tinos',
    );
    return _apply(base, scheme);
  }

  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF1FB8B8),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFFD9B75B),
          secondary: const Color(0xFF1FB8B8),
          tertiary: const Color(0xFF22D3EE),
          surface: const Color(0xFF0F1026),
          surfaceContainerHighest: const Color(0xFF15182B),
          onSurface: const Color(0xFFF5F5F5),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      fontFamily: 'Tinos',
    );
    return _apply(base, scheme);
  }

  static ThemeData _apply(ThemeData base, ColorScheme scheme) {
    final textTheme = base.textTheme.copyWith(
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.6),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.6),
      bodySmall: base.textTheme.bodySmall?.copyWith(height: 1.6),
    );
    return base.copyWith(
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
