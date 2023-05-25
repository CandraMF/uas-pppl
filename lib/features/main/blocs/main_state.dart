part of 'main_cubit.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    required int menuId,
  }) = _MainState;

  factory MainState.initial() => const _MainState(
        menuId: 0,
      );
}
