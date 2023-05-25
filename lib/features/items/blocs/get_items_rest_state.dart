part of 'get_items_rest_cubit.dart';

@freezed
class GetItemsRestState with _$GetItemsRestState {
  const factory GetItemsRestState.failed({required AlertModel alert}) =
      _GetItemsRestStateFailed;

  const factory GetItemsRestState.initial() = _GetItemsRestStateInitial;

  const factory GetItemsRestState.success({
    required PaginatedModel<ItemRestModel> items,
  }) = _GetItemsRestStateSuccess;

  const factory GetItemsRestState.refresh() = _GetItemsRestStateRefresh;

  const factory GetItemsRestState.loading() = _GetItemsRestStateLoading;
}
