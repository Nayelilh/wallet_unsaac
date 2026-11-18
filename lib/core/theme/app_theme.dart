// Reto 4 — lib/core/theme/app_theme.dart  (parametriza el color semilla)
import 'package:flutter/material.dart';

abstract final class AppTheme {
  /// Semilla institucional por defecto: granate UNSAAC.
  static const Color seed = Color(0xFF7A1F2B);

  /// Cuatro colores semilla que el usuario puede elegir.
  static const List<Color> seeds = <Color>[
    Color(0xFF7A1F2B), // Granate UNSAAC
    Color(0xFF1B5E20), // Verde andino
    Color(0xFF0D47A1), // Azul lectura
    Color(0xFFEF6C00), // Naranja energía
  ];

  static ThemeData light({Color? seedColor}) =>
      _build(Brightness.light, seedColor ?? seed);

  static ThemeData dark({Color? seedColor}) =>
      _build(Brightness.dark, seedColor ?? seed);

  static ThemeData _build(Brightness brightness, Color seedColor) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
