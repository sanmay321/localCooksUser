import 'package:artools/artools.dart';
import 'package:localcooks_app/app/models/shops/shops.dart';

class ShopCart extends Model{
  String? message;
  int? status;
  CartCount? data;

  ShopCart({
    this.status,
    this.message,
    this.data
  });

  factory ShopCart.fromJson(JsonMap json) {
    return ShopCart(
      status: Model.intFromJson(json, 'status'),
      message: Model.stringFromJson(json, 'message'),
      data: CartCount.fromJson(json["data"]),
    );
  }

  JsonMap toJson() {
    return {
      'status': status,
      'message': message,
      'data': data!.toJson(),
    };
  }

  @override
  String toString() {
    return 'ShopCart{'
        'status: $status, '
        'message: $message, '
        'data: ${data!.toJson()}, '
        '}';
  }
}

class CartCount extends Model{
  int total_items = 0;

  CartCount({this.total_items = 0});

  factory CartCount.fromJson(JsonMap json) {
    return CartCount(
      total_items: Model.intFromJson(json, 'total_items') ?? 0,
    );
  }

  JsonMap toJson() {
    return {
      'total_items': total_items,
    };
  }

  @override
  String toString() {
    return 'CartCount{'
        'total_items: $total_items'
        '}';
  }

}