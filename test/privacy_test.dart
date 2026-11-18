// Reto 2 — test/privacy_test.dart  (Cubit + widget)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/privacy_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/balance_card.dart';

WalletSummary _summary() => WalletSummary(
  movements: <Movement>[
    Movement(
      id: 't1',
      title: 'Sueldo',
      category: 'Trabajo',
      amount: 1200,
      type: MovementType.income,
      date: DateTime(2026, 11, 2),
    ),
  ],
);

void main() {
  group('PrivacyCubit', () {
    test('estado inicial visible', () {
      final cubit = PrivacyCubit();
      expect(cubit.state, const PrivacyState(balanceHidden: false));
    });

    test('toggle oculta y luego muestra', () {
      final cubit = PrivacyCubit();
      cubit.toggle();
      expect(cubit.state.balanceHidden, isTrue);
      cubit.toggle();
      expect(cubit.state.balanceHidden, isFalse);
    });

    test('hide y show son explícitos', () {
      final cubit = PrivacyCubit();
      cubit.hide();
      expect(cubit.state.balanceHidden, isTrue);
      cubit.show();
      expect(cubit.state.balanceHidden, isFalse);
    });
  });

  group('BalanceCard widget', () {
    testWidgets('muestra el saldo real cuando no está oculto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              summary: _summary(),
              hideBalance: false,
              onTogglePrivacy: () {},
            ),
          ),
        ),
      );
      // 1,200 aparece en el saldo y en ingresos.
      expect(find.textContaining('1,200'), findsWidgets);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('muestra la máscara cuando está oculto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (_) => PrivacyCubit()..hide(),
              child: Builder(
                builder: (context) => BlocBuilder<PrivacyCubit, PrivacyState>(
                  builder: (_, state) => BalanceCard(
                    summary: _summary(),
                    hideBalance: state.balanceHidden,
                    onTogglePrivacy: () =>
                        context.read<PrivacyCubit>().toggle(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.textContaining('••••••'), findsWidgets);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
