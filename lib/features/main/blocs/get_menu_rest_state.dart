part of 'get_menu_rest_cubit.dart';

@freezed
class GetMenuRestState with _$GetMenuRestState {
  const factory GetMenuRestState.failed({required AlertModel alert}) =
      _GetMenuRestStateFailed;

  const factory GetMenuRestState.initial() = _GetMenuRestStateInitial;

  const factory GetMenuRestState.success({
    required PaginatedModel<MenuRestModel> menus,
  }) = _GetMenuRestStateSuccess;

  const factory GetMenuRestState.refresh() = _GetMenuRestStateRefresh;

  const factory GetMenuRestState.loading() = _GetMenuRestStateLoading;
}
