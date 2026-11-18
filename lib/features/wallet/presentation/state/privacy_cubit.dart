// Reto 2 — lib/features/wallet/presentation/state/privacy_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/features/wallet/presentation/state/privacy_state.dart';

/// `Cubit` que gobierna la visibilidad de los importes.
///
/// No persiste: la privacidad es efímera (el usuario la activa al viajar en
/// bus y la desactiva al llegar a casa). Mientras la app está abierta, el
/// estado se conserva en el Cubit.
class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit() : super(const PrivacyState());

  void toggle() =>
      emit(state.copyWith(balanceHidden: !state.balanceHidden));

  void hide() => emit(const PrivacyState(balanceHidden: true));
  void show() => emit(const PrivacyState(balanceHidden: false));
}
