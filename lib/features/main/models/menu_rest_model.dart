import 'package:freezed_annotation/freezed_annotation.dart';
part 'menu_rest_model.freezed.dart';
part 'menu_rest_model.g.dart';

@freezed
class MenuRestModel with _$MenuRestModel {
  const factory MenuRestModel({
    required int id,
    required String nama,
    required String foto,
  }) = _MenuRestModel;

  factory MenuRestModel.initial() => const MenuRestModel(
        id: 0,
        nama: '',
        foto: '',
      );

  factory MenuRestModel.fromJson(Map<String, dynamic> json) =>
      _$MenuRestModelFromJson(json);
}
