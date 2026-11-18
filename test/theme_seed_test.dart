// Reto 4 — test/theme_seed_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';

void main() {
  group('AppTheme seed', () {
    test('cambiar la semilla cambia el primary resultante', () {
      final a = AppTheme.light(seedColor: const Color(0xFF7A1F2B)).colorScheme;
      final b = AppTheme.light(seedColor: const Color(0xFF1B5E20)).colorScheme;
      expect(a.primary, isNot(b.primary));
    });

    test('el primary coincide con ColorScheme.fromSeed de la misma semilla', () {
      const seed = Color(0xFF0D47A1);
      final theme = AppTheme.light(seedColor: seed);
      final expected = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      );
      expect(theme.colorScheme.primary, expected.primary);
    });
  });

  group('ThemeState igualdad', () {
    test('seedColor participa en la igualdad', () {
      const s1 = ThemeState(
          mode: ThemeMode.dark, seedColor: Color(0xFF7A1F2B));
      const s2 = ThemeState(
          mode: ThemeMode.dark, seedColor: Color(0xFF1B5E20));
      expect(s1 == s2, isFalse);
      const s3 = ThemeState(
          mode: ThemeMode.dark, seedColor: Color(0xFF7A1F2B));
      expect(s1 == s3, isTrue);
    });
  });

  group('ThemeCubit setSeedColor', () {
    test('cambia la semilla sin perder el modo', () {
      final cubit = ThemeCubit();
      cubit.toggle(); // modo dark
      final modeBefore = cubit.state.mode;
      cubit.setSeedColor(const Color(0xFFEF6C00));
      expect(cubit.state.seedColor, const Color(0xFFEF6C00));
      expect(cubit.state.mode, modeBefore); // el modo se conserva
    });
  });
}
