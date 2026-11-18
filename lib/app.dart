// lib/app.dart
// FUSIÓN Reto 1 + Reto 4: inyecta las preferencias y el modo inicial (R1) y
// construye el tema con el color semilla del estado (R4).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/in_memory_wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/pages/wallet_home_page.dart';

/// Raíz de la aplicación.
///
/// Aquí se inyectan las dependencias que el resto del árbol necesita:
/// - `RepositoryProvider<WalletRepository>`: capa de datos disponible para
///   cualquier pantalla o bloc.
/// - `RepositoryProvider<ThemePreferences>`: almacenamiento del tema (Reto 1).
/// - `BlocProvider<ThemeCubit>`: estado global del tema (modo + semilla).
class WalletApp extends StatelessWidget {
  const WalletApp({
    super.key,
    required this.firebaseStatus,
    required this.themePreferences,
    required this.initialThemeMode,
  });

  final FirebaseStatus firebaseStatus;
  final ThemePreferences themePreferences;
  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WalletRepository>(
          create: (_) => InMemoryWalletRepository(),
        ),
        RepositoryProvider<ThemePreferences>.value(value: themePreferences),
      ],
      child: BlocProvider(
        create: (_) => ThemeCubit(
          preferences: themePreferences,
          initialMode: initialThemeMode,
        ),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Wallet UNSAAC',
              debugShowCheckedModeBanner: false,
              // Reto 4: el tema se construye con el color semilla del estado.
              theme: AppTheme.light(seedColor: themeState.seedColor),
              darkTheme: AppTheme.dark(seedColor: themeState.seedColor),
              // Reto 1: el modo se recuperó antes de runApp.
              themeMode: themeState.mode,
              home: WalletHomePage(firebaseStatus: firebaseStatus),
            );
          },
        ),
      ),
    );
  }
}
