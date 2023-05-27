import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/dio_exception_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MenuRestRepository {
  MenuRestRepository(this._dioClient);

  final Dio _dioClient;

  Future<DC<AlertModel, PaginatedModel<MenuRestModel>>> getMenu(
    int page,
    int size,
  ) async {
    return dioExceptionHandler<PaginatedModel<MenuRestModel>>(() async {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/api/jenis_menu?page=$page',
      );

      final data = response.data?['data'] as List<dynamic>;
      final menus = data
          .map((p) => MenuRestModel.fromJson(p as Map<String, dynamic>))
          .toList();
      final total = response.data?['total'] as int;

      final paginatedMenu = PaginatedModel(
        currentPage: page,
        size: size,
        total: total,
        items: menus,
      );

      /* final paginatedMenu = PaginatedModel<MenuRestModel>.fromJson(
        response.data ?? {},
        (json) => MenuRestModel.fromJson((json ?? {}) as Map<String, dynamic>),
      ); */

      return DC.data(paginatedMenu);
    });
  }
}
