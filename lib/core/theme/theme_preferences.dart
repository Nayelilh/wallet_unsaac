// Reto 1 — lib/core/theme/theme_preferences.dart
// Almacenamiento del modo de tema, aislado en una interfaz para poder probarlo.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrato de almacenamiento del modo de tema.
///
/// Vive en `core/theme` para probarse aislado de la interfaz y, en el futuro,
/// sustituir la implementación sin tocar el Cubit.
abstract interface class ThemePreferences {
  Future<ThemeMode?> readMode();
  Future<void> writeMode(ThemeMode mode);
}

/// Implementación basada en `shared_preferences`.
///
/// El valor se guarda como texto (nombre del enum). Si el valor guardado no
/// coincide con ningún `ThemeMode`, `readMode` devuelve `null` en lugar de
/// lanzar una excepción: así un dato corrupto no rompe el arranque.
class SharedPreferencesThemePreferences implements ThemePreferences {
  SharedPreferencesThemePreferences({this.instance});

  final SharedPreferences? instance;

  static const String _key = 'wallet.theme.mode';

  Future<SharedPreferences> _prefs() async {
    return instance ?? SharedPreferences.getInstance();
  }

  @override
  Future<ThemeMode?> readMode() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return _parseMode(raw);
  }

  @override
  Future<void> writeMode(ThemeMode mode) async {
    final prefs = await _prefs();
    await prefs.setString(_key, mode.name);
  }

  static ThemeMode? _parseMode(String raw) {
    for (final mode in ThemeMode.values) {
      if (mode.name == raw) return mode;
    }
    return null;
  }
}
