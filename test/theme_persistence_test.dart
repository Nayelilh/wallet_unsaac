// Reto 1 — test/theme_persistence_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('SharedPreferencesThemePreferences', () {
    test('recupera null cuando no hay valor guardado', () async {
      final prefs = SharedPreferencesThemePreferences();
      expect(await prefs.readMode(), isNull);
    });

    test('guarda y recupera un modo válido', () async {
      final prefs = SharedPreferencesThemePreferences();
      await prefs.writeMode(ThemeMode.dark);
      expect(await prefs.readMode(), ThemeMode.dark);
    });

    test('un valor corrupto devuelve null sin lanzar excepción', () async {
      SharedPreferences.setMockInitialValues({'wallet.theme.mode': 'PURPLE'});
      final prefs = SharedPreferencesThemePreferences();
      expect(await prefs.readMode(), isNull);
    });
  });

  group('ThemeCubit persistencia', () {
    test('persiste el modo al cambiarlo con setMode', () async {
      final prefs = SharedPreferencesThemePreferences();
      final cubit = ThemeCubit(preferences: prefs);
      await cubit.setMode(ThemeMode.dark);
      expect(cubit.state.mode, ThemeMode.dark);
      expect(await prefs.readMode(), ThemeMode.dark);
    });

    test('recorre claro → oscuro → sistema → claro', () async {
      final cubit = ThemeCubit(
        preferences: SharedPreferencesThemePreferences(),
        initialMode: ThemeMode.light,
      );
      await cubit.cycle();
      expect(cubit.state.mode, ThemeMode.dark);
      await cubit.cycle();
      expect(cubit.state.mode, ThemeMode.system);
      await cubit.cycle();
      expect(cubit.state.mode, ThemeMode.light);
    });
  });
}
