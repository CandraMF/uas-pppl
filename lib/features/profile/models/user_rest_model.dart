import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_rest_model.freezed.dart';
part 'user_rest_model.g.dart';

@freezed
class UserRestModel with _$UserRestModel {
  const factory UserRestModel({
    required int id,
    required String email,
    required String name,
  }) = _UserRestModel;

  factory UserRestModel.initial() => const UserRestModel(
        id: 0,
        email: '',
        name: '',
      );

  factory UserRestModel.fromJson(Map<String, dynamic> json) =>
      _$UserRestModelFromJson(json);
}
