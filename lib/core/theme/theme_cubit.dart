import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    this.preferences,
    ThemeMode initialMode = ThemeMode.system,
    Color initialSeed = AppTheme.seed,
  }) : super(ThemeState(mode: initialMode, seedColor: initialSeed));

  final ThemePreferences? preferences;

  Future<void> setMode(ThemeMode mode) async {
    emit(state.copyWith(mode: mode));
    try {
      await preferences?.writeMode(mode);
    } on Exception {
      // La persistencia es best-effort.
    }
  }

  Future<void> cycle() {
    final next = switch (state.mode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    return setMode(next);
  }

  Future<void> toggle() =>
      setMode(state.isDark ? ThemeMode.light : ThemeMode.dark);

  void setSeedColor(Color color) => emit(state.copyWith(seedColor: color));
}
