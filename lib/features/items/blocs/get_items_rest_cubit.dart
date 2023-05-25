import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/items/models/item_rest_model.dart';
import 'package:flutter_advanced_boilerplate/features/items/networking/items_rest_repository.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_items_rest_cubit.freezed.dart';
part 'get_items_rest_state.dart';

@injectable
class GetItemsRestCubit extends Cubit<GetItemsRestState> {
  GetItemsRestCubit(this._itemsRestRepository)
      : super(const GetItemsRestState.initial());

  final ItemsRestRepository _itemsRestRepository;
  final MainCubit _maincubit = getIt<MainCubit>();

  Future<void> getItems(
    int page, {
    int? size,
    int? type,
  }) async {
    emit(const GetItemsRestState.loading());

    final response = await _itemsRestRepository.getItems(
      page,
      size ?? $constants.api.maxItemToBeFetchedAtOneTime,
      type ?? _maincubit.getMenuId(),
    );

    response.pick(
      onError: (error) {
        emit(GetItemsRestState.failed(alert: error));
      },
      onData: (items) {
        emit(GetItemsRestState.success(items: items));
      },
    );
  }

  void refreshList() {
    emit(const GetItemsRestState.refresh());
  }
}
