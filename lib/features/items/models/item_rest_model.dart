import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_rest_model.freezed.dart';
part 'item_rest_model.g.dart';

@freezed
class ItemRestModel with _$ItemRestModel {
  const factory ItemRestModel({
    required int id,
    required String nama,
    required String deskripsi,
    required int harga,
    required int jenis,
    required String foto,
  }) = _ItemRestModel;

  factory ItemRestModel.initial() => const ItemRestModel(
        id: 0,
        nama: "",
        deskripsi: "",
        harga: 0,
        jenis: 0,
        foto: "",
      );

  factory ItemRestModel.fromJson(Map<String, dynamic> json) =>
      _$ItemRestModelFromJson(json);
}
