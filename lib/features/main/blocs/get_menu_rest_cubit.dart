import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:flutter_advanced_boilerplate/features/main/networking/menu_rest_repository.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_menu_rest_cubit.freezed.dart';
part 'get_menu_rest_state.dart';

@injectable
class GetMenuRestCubit extends Cubit<GetMenuRestState> {
  GetMenuRestCubit(this._menuRestRepository)
      : super(const GetMenuRestState.initial());

  final MenuRestRepository _menuRestRepository;
  final MainCubit _maincubit = getIt<MainCubit>();

  Future<void> getMenu(
    int page, {
    int? size,
  }) async {
    emit(const GetMenuRestState.loading());

    final response = await _menuRestRepository.getMenu(
      page,
      size ?? $constants.api.maxItemToBeFetchedAtOneTime,
    );

    response.pick(
      onError: (error) {
        emit(GetMenuRestState.failed(alert: error));
      },
      onData: (menu) {
        emit(GetMenuRestState.success(menus: menu));
      },
    );
  }

  void refreshList() {
    emit(const GetMenuRestState.refresh());
  }
}
