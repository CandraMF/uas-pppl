part of 'get_users_rest_cubit.dart';

@freezed
class GetUsersRestState with _$GetUsersRestState {
  const factory GetUsersRestState.failed({required AlertModel alert}) =
      _GetUsersRestStateFailed;

  const factory GetUsersRestState.initial() = _GetUsersRestStateInitial;

  const factory GetUsersRestState.success({
    required PaginatedModel<UserRestModel> users,
  }) = _GetUsersRestStateSuccess;

  const factory GetUsersRestState.refresh() = _GetUsersRestStateRefresh;

  const factory GetUsersRestState.loading() = _GetUsersRestStateLoading;
}
