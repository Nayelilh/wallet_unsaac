// Reto 3 — lib/features/wallet/presentation/state/balance_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/balance_state.dart';

/// `Cubit` que carga el resumen y emite estados tipados.
///
/// Reemplaza al `FutureBuilder` de la pantalla: la lógica de carga vive aquí,
/// la interfaz solo reacciona al estado. El repositorio se inyecta por
/// constructor, así la pantalla nunca lo toca y las pruebas pueden sustituirlo.
class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({required this.repository}) : super(const BalanceInitial());

  final WalletRepository repository;

  /// Carga el resumen. Emite `BalanceLoading` y luego éxito o fallo.
  /// `isClosed` evita emitir sobre un Cubit ya cerrado (típico tras un
  /// `await` si el widget se desmontó antes de responder).
  Future<void> load() async {
    emit(const BalanceLoading());
    try {
      final summary = await repository.loadSummary();
      if (!isClosed) emit(BalanceSuccess(summary));
    } on Exception catch (e) {
      if (!isClosed) emit(BalanceFailure(e.toString()));
    }
  }
}
