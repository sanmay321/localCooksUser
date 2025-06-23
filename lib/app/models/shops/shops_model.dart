import 'package:artools/artools.dart';
import 'package:localcooks_app/app/models/shops/shops.dart';

class ShopsModel extends Model{
  String? message;
  int? status;
  List<Shops>? data;

  ShopsModel({
    this.status,
    this.message,
    this.data
  });

  factory ShopsModel.fromJson(JsonMap json) {
    return ShopsModel(
      status: Model.intFromJson(json, 'status'),
      message: Model.stringFromJson(json, 'message'),
      data: Model.listFromJson(json, "data", (profile) => Shops.fromJson(profile)),
    );
  }

  JsonMap toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ProfileModel{'
        'status: $status, '
        'message: $message, '
        '}';
  }
}