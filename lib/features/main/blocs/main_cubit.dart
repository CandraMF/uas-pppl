import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'main_cubit.freezed.dart';
part 'main_state.dart';

@lazySingleton
class MainCubit extends HydratedCubit<MainState> {
  MainCubit() : super(MainState.initial());

  void changeMenuId({required int index}) => emit(
        state.copyWith(
          menuId: index,
        ),
      );

  int getMenuId() => state.menuId;

  @override
  MainState? fromJson(Map<String, dynamic> json) {
    return const MainState(menuId: 0);
  }

  @override
  Map<String, dynamic>? toJson(MainState state) {
    return {
      'menuId': state.menuId,
    };
  }
}
