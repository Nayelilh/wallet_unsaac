// Reto 4 — lib/core/theme/theme_state.dart  (añade seedColor)
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';

/// Estado del tema: modo claro/oscuro/sistema + color semilla.
class ThemeState extends Equatable {
  const ThemeState({
    this.mode = ThemeMode.system,
    this.seedColor = AppTheme.seed,
  });

  final ThemeMode mode;
  final Color seedColor;

  bool get isDark => mode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? mode, Color? seedColor}) => ThemeState(
        mode: mode ?? this.mode,
        seedColor: seedColor ?? this.seedColor,
      );

  /// `seedColor` entra en props: dos estados con la misma semilla y modo son
  /// iguales, y BLoC omite emisiones redundantes.
  @override
  List<Object?> get props => [mode, seedColor];
}
