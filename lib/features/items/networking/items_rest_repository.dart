import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/items/models/item_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/dio_exception_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ItemsRestRepository {
  ItemsRestRepository(this._dioClient);

  final Dio _dioClient;

  Future<DC<AlertModel, PaginatedModel<ItemRestModel>>> getItems(
    int page,
    int size,
    int type,
  ) async {
    return dioExceptionHandler<PaginatedModel<ItemRestModel>>(() async {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/api/produk?page=$page&type=$type',
      );

      final data = response.data?['data'] as List<dynamic>;
      final items = data
          .map((p) => ItemRestModel.fromJson(p as Map<String, dynamic>))
          .toList();
      final total = response.data?['total'] as int;

      final paginatedItems = PaginatedModel(
        currentPage: page,
        size: size,
        total: total,
        items: items,
      );

      /* final paginatedItems = PaginatedModel<ItemRestModel>.fromJson(
        response.data ?? {},
        (json) => ItemRestModel.fromJson((json ?? {}) as Map<String, dynamic>),
      ); */

      return DC.data(paginatedItems);
    });
  }
}
