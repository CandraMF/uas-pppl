import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/paginated_model.dart';
import 'package:flutter_advanced_boilerplate/features/profile/models/user_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/dio_exception_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UsersRestRepository {
  UsersRestRepository(this._dioClient);

  final Dio _dioClient;

  Future<DC<AlertModel, PaginatedModel<UserRestModel>>> getUsers(
    int page,
    int size,
  ) async {
    return dioExceptionHandler<PaginatedModel<UserRestModel>>(() async {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/api/user?page=$page',
      );

      final data = response.data?['data'] as List<dynamic>;
      final users = data
          .map((p) => UserRestModel.fromJson(p as Map<String, dynamic>))
          .toList();
      final total = response.data?['total'] as int;

      final paginatedUsers = PaginatedModel(
        currentPage: page,
        size: size,
        total: total,
        items: users,
      );

      /* final paginatedUsers = PaginatedModel<UserRestModel>.fromJson(
        response.data ?? {},
        (json) => UserRestModel.fromJson((json ?? {}) as Map<String, dynamic>),
      ); */

      return DC.data(paginatedUsers);
    });
  }
}
