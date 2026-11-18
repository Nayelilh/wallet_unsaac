// Reto 2 — lib/features/wallet/presentation/state/privacy_state.dart
import 'package:equatable/equatable.dart';

/// Estado de privacidad de los importes en pantalla.
///
/// Es un estado de PRESENTACIÓN: decide si los importes se dibujan o se
/// enmascaran. No toca el dominio: el saldo real sigue siendo exacto en
/// `WalletSummary`; solo se oculta su representación visual.
class PrivacyState extends Equatable {
  const PrivacyState({this.balanceHidden = false});

  final bool balanceHidden;

  PrivacyState copyWith({bool? balanceHidden}) =>
      PrivacyState(balanceHidden: balanceHidden ?? this.balanceHidden);

  @override
  List<Object?> get props => [balanceHidden];
}
