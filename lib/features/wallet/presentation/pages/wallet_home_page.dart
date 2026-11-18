// lib/features/wallet/presentation/pages/wallet_home_page.dart
// FUSIÓN Reto 2 + Reto 3 + Reto 4 (+ Reto 1 en el AppBar):
// - Reto 3: BalanceCubit gobierna la carga (carga/éxito/error) y reemplaza
//   al FutureBuilder; la pantalla no toca el repositorio.
// - Reto 2: PrivacyCubit oculta/muestra todos los importes.
// - Reto 4: selector de color semilla con BlocSelector.
// - Reto 1: botón de ciclo de tema claro → oscuro → sistema.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/balance_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/privacy_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/balance_card.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/firebase_status_card.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/movement_tile.dart';

/// Pantalla principal de Wallet UNSAAC.
class WalletHomePage extends StatelessWidget {
  const WalletHomePage({super.key, required this.firebaseStatus});

  final FirebaseStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Reto 3: el Cubit carga al crearse; el repositorio viene inyectado.
        BlocProvider(
          create: (ctx) =>
              BalanceCubit(repository: ctx.read<WalletRepository>())..load(),
        ),
        // Reto 2: estado de privacidad de los importes.
        BlocProvider(create: (_) => PrivacyCubit()),
      ],
      child: _WalletHomeView(firebaseStatus: firebaseStatus),
    );
  }
}

class _WalletHomeView extends StatelessWidget {
  const _WalletHomeView({required this.firebaseStatus});

  final FirebaseStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Reto 1: el icono refleja el modo actual (claro / oscuro / sistema).
    final mode = context.select((ThemeCubit c) => c.state.mode);
    final (themeIcon, themeTip) = switch (mode) {
      ThemeMode.light => (
        Icons.light_mode_outlined,
        'Tema claro (tocar para oscuro)',
      ),
      ThemeMode.dark => (
        Icons.dark_mode_outlined,
        'Tema oscuro (tocar para sistema)',
      ),
      ThemeMode.system => (
        Icons.brightness_auto_outlined,
        'Tema del sistema (tocar para claro)',
      ),
    };

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Wallet UNSAAC',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
        actions: [
          // Reto 4: selector de color semilla (el icono refleja el color activo).
          IconButton(
            tooltip: 'Color de tema',
            icon: BlocSelector<ThemeCubit, ThemeState, Color>(
              selector: (s) => s.seedColor,
              builder: (_, seed) => Icon(Icons.palette_outlined, color: seed),
            ),
            onPressed: () => _showSeedPicker(context),
          ),
          // Reto 2: ocultar/mostrar todos los importes.
          IconButton(
            tooltip: context.select((PrivacyCubit c) => c.state.balanceHidden)
                ? 'Mostrar importes'
                : 'Ocultar importes',
            icon: Icon(
              context.select((PrivacyCubit c) => c.state.balanceHidden)
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => context.read<PrivacyCubit>().toggle(),
          ),
          // Reto 1: ciclo claro → oscuro → sistema → claro.
          IconButton(
            tooltip: themeTip,
            icon: Icon(themeIcon),
            onPressed: () => context.read<ThemeCubit>().cycle(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Reto 3: la pantalla solo reacciona al estado del BalanceCubit.
      body: BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) {
          return switch (state) {
            BalanceInitial _ || BalanceLoading _ => const Center(
              child: CircularProgressIndicator(),
            ),
            BalanceFailure(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<BalanceCubit>().load(),
            ),
            BalanceSuccess(:final summary) =>
              // Reto 2: el estado de privacidad envuelve la lista.
              BlocBuilder<PrivacyCubit, PrivacyState>(
                builder: (context, privacy) => RefreshIndicator(
                  onRefresh: () => context.read<BalanceCubit>().load(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      BalanceCard(
                        summary: summary,
                        hideBalance: privacy.balanceHidden,
                        onTogglePrivacy: () =>
                            context.read<PrivacyCubit>().toggle(),
                      ),
                      const SizedBox(height: 20),
                      for (final m in summary.movements) ...[
                        MovementTile(
                          movement: m,
                          hideAmount: privacy.balanceHidden,
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 12),
                      FirebaseStatusCard(status: firebaseStatus),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
    );
  }

  /// Reto 4: hoja inferior con los colores semilla disponibles.
  void _showSeedPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Color de tema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final seed in AppTheme.seeds)
                    BlocSelector<ThemeCubit, ThemeState, Color>(
                      selector: (s) => s.seedColor,
                      builder: (_, active) => _SeedDot(
                        color: seed,
                        selected: seed == active,
                        onTap: () {
                          sheetCtx.read<ThemeCubit>().setSeedColor(seed);
                          Navigator.pop(sheetCtx);
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Círculo de color semilla con marca de selección (Reto 4).
class _SeedDot extends StatelessWidget {
  const _SeedDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.fromBorderSide(
                  BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                )
              : null,
        ),
        child: selected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}

/// Vista de error con botón Reintentar (Reto 3).
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: scheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
