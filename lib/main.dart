import 'package:flutter/material.dart';
import 'package:wallet_unsaac/app.dart';
import 'package:wallet_unsaac/core/config/firebase_bootstrap.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';

/// Punto de entrada de Wallet UNSAAC.
///
/// Orden de arranque (Reto 1):
/// 1. Se inicializa el binding de Flutter para poder usar plugins antes de
///    `runApp`.
/// 2. Se lee el modo de tema guardado; así el primer frame ya usa el modo
///    correcto y no hay parpadeo de un arranque en modo `system` que después
///    cambia a oscuro.
/// 3. Firebase se inicializa sin bloquear el arranque.
/// 4. `runApp` construye el árbol con el modo inicial ya resuelto.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = SharedPreferencesThemePreferences();
  final savedMode = await preferences
      .readMode(); // null si no hay o está corrupto
  final firebaseStatus = await FirebaseBootstrap.initialize();
  runApp(
    WalletApp(
      firebaseStatus: firebaseStatus,
      themePreferences: preferences,
      initialThemeMode: savedMode ?? ThemeMode.system,
    ),
  );
}
