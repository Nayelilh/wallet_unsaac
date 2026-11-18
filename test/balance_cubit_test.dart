// Reto 3 — test/balance_cubit_test.dart  (éxito, fallo, reintento con blocTest)
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/in_memory_wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/balance_state.dart';

class _FailingRepository implements WalletRepository {
  @override
  Future<WalletSummary> loadSummary() =>
      throw Exception('No se pudo contactar al servicio de la billetera.');
}

WalletSummary _summary() => WalletSummary(movements: <Movement>[
      Movement(
          id: 't1',
          title: 'Sueldo',
          category: 'Trabajo',
          amount: 1200,
          type: MovementType.income,
          date: DateTime(2026, 11, 2)),
    ]);

void main() {
  group('BalanceCubit', () {
    blocTest<BalanceCubit, BalanceState>(
      'emite Loading → Success cuando el repositorio responde',
      build: () => BalanceCubit(
          repository: InMemoryWalletRepository(
              latency: Duration.zero, movements: [
            Movement(
                id: 't1',
                title: 'Sueldo',
                category: 'Trabajo',
                amount: 1200,
                type: MovementType.income,
                date: DateTime(2026, 11, 2)),
          ])),
      act: (cubit) => cubit.load(),
      expect: () => [isA<BalanceLoading>(), isA<BalanceSuccess>()],
    );

    blocTest<BalanceCubit, BalanceState>(
      'emite Loading → Failure cuando el repositorio falla',
      build: () => BalanceCubit(repository: _FailingRepository()),
      act: (cubit) => cubit.load(),
      expect: () => [isA<BalanceLoading>(), isA<BalanceFailure>()],
    );

    blocTest<BalanceCubit, BalanceState>(
      'Reintentar vuelve a consultar: Loading → Success → Loading → Failure',
      build: () => BalanceCubit(repository: _FlipFlopRepository()),
      act: (cubit) async {
        await cubit.load(); // success
        await cubit.load(); // failure
      },
      expect: () => [
        isA<BalanceLoading>(),
        isA<BalanceSuccess>(),
        isA<BalanceLoading>(),
        isA<BalanceFailure>(),
      ],
    );
  });
}

/// Repositorio que falla en la segunda llamada: prueba el reintento real.
class _FlipFlopRepository implements WalletRepository {
  int _calls = 0;
  @override
  Future<WalletSummary> loadSummary() {
    _calls++;
    if (_calls == 1) {
      return Future.value(_summary());
    }
    return Future.error(Exception('El servicio falló al reintentar.'));
  }
}
