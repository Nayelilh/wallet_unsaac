// Reto 3 — lib/features/wallet/presentation/state/balance_state.dart
// Jerarquía sellada de estados del saldo.
import 'package:equatable/equatable.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';

/// Estados posibles de la carga del resumen de la billetera.
///
/// `sealed` obliga a la interfaz a cubrir TODOS los casos en un `switch`,
/// de modo que el compilador avisa si se añade un estado nuevo y no se atiende.
sealed class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object?> get props => [];
}

class BalanceInitial extends BalanceState {
  const BalanceInitial();
}

class BalanceLoading extends BalanceState {
  const BalanceLoading();
}

class BalanceSuccess extends BalanceState {
  const BalanceSuccess(this.summary);
  final WalletSummary summary;
  @override
  List<Object?> get props => [summary];
}

class BalanceFailure extends BalanceState {
  const BalanceFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
