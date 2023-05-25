import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/profile/models/user_rest_model.dart';
import 'package:flutter_advanced_boilerplate/features/profile/networking/users_rest_repository.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_users_rest_cubit.freezed.dart';
part 'get_users_rest_state.dart';

@injectable
class GetUsersRestCubit extends Cubit<GetUsersRestState> {
  GetUsersRestCubit(this._usersRestRepository)
      : super(const GetUsersRestState.initial());

  final UsersRestRepository _usersRestRepository;

  Future<void> getUsers(
    int page, {
    int? size,
  }) async {
    emit(const GetUsersRestState.loading());

    final response = await _usersRestRepository.getUsers(
      page,
      size ?? $constants.api.maxItemToBeFetchedAtOneTime,
    );

    response.pick(
      onError: (error) {
        emit(GetUsersRestState.failed(alert: error));
      },
      onData: (users) {
        emit(GetUsersRestState.success(users: users));
      },
    );
  }

  void refreshList() {
    emit(const GetUsersRestState.refresh());
  }
}
