import 'dart:convert';

class Cart {
  int? status;
  CartData? data;
  String? message;

  Cart({this.status, this.data, this.message});

  Cart.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class CartData {
  Shop? shop;
  List<CartItems>? cartItems;
  String? totalProductListing;
  double? totalPrice;

  CartData({this.shop, this.cartItems, this.totalProductListing, this.totalPrice});

  CartData.fromJson(Map<String, dynamic> json) {
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
    totalProductListing = json['total_product_listing'];
    totalPrice = double.parse(json['total_price']?.toString() ?? "0.0");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.cartItems != null) {
      data['cart_items'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    data['total_product_listing'] = this.totalProductListing;
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class Shop {
  String? lid;
  String? sname;
  String? simage;
  String? acceptPreorders;

  Shop({this.lid, this.sname, this.simage, this.acceptPreorders});

  Shop.fromJson(Map<String, dynamic> json) {
    lid = json['lid'];
    sname = json['sname'];
    simage = json['simage'];
    acceptPreorders = json['accept_preorders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lid'] = this.lid;
    data['sname'] = this.sname;
    data['simage'] = this.simage;
    data['accept_preorders'] = this.acceptPreorders;
    return data;
  }
}

CartItems cartItemsFromJson(String str) => CartItems.fromJson(json.decode(str));

String cartItemsToJson(CartItems data) => json.encode(data.toJson());

class CartItems {
  String? cartid;
  String? sid;
  String? pid;
  String? uid;
  String? qty;
  String? price;
  String? pprice;
  String? pvi;
  List<Addons>? addons;
  String? preorderTime;
  String? cid;
  String? pname;
  String? punit;
  String? mrp;
  String? pdesc;
  String? pimage;
  String? status;
  String? maxAddons;
  String? minAddons;
  String? unit;
  String? addonNames;
  int? addonTotal;
  double? itemTotal;

  CartItems(
      {this.cartid,
        this.sid,
        this.pid,
        this.uid,
        this.qty,
        this.price,
        this.pprice,
        this.pvi,
        this.addons,
        this.preorderTime,
        this.cid,
        this.pname,
        this.punit,
        this.mrp,
        this.pdesc,
        this.pimage,
        this.status,
        this.maxAddons,
        this.minAddons,
        this.unit,
        this.addonNames,
        this.addonTotal,
        this.itemTotal});

  CartItems.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    sid = json['sid'];
    pid = json['pid'];
    uid = json['uid'];
    qty = json['qty'];
    price = json['price'];
    pprice = json['pprice'];
    pvi = json['pvi'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(new Addons.fromJson(v));
      });
    }
    preorderTime = json['preorder_time'];
    cid = json['cid'];
    pname = json['pname'];
    punit = json['punit'];
    mrp = json['mrp'];
    pdesc = json['pdesc'];
    pimage = json['pimage'];
    status = json['status'];
    maxAddons = json['max_addons'];
    minAddons = json['min_addons'];
    unit = json['unit'];
    addonNames = json['addon_names'];
    addonTotal = json['addon_total'];
    itemTotal = double.parse(json['item_total']?.toString() ?? "0.0");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartid'] = this.cartid;
    data['sid'] = this.sid;
    data['pid'] = this.pid;
    data['uid'] = this.uid;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['pprice'] = this.pprice;
    data['pvi'] = this.pvi;
    if (this.addons != null) {
      data['addons'] = this.addons!.map((v) => v.toJson()).toList();
    }
    data['preorder_time'] = this.preorderTime;
    data['cid'] = this.cid;
    data['pname'] = this.pname;
    data['punit'] = this.punit;
    data['mrp'] = this.mrp;
    data['pdesc'] = this.pdesc;
    data['pimage'] = this.pimage;
    data['status'] = this.status;
    data['max_addons'] = this.maxAddons;
    data['min_addons'] = this.minAddons;
    data['unit'] = this.unit;
    data['addon_names'] = this.addonNames;
    data['addon_total'] = this.addonTotal;
    data['item_total'] = this.itemTotal;
    return data;
  }
}

class Addons {
  String? name;
  num? price;

  Addons({this.name, this.price});

  Addons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    //price = json['price'];
    if(json['price'] != null){
      if(json['price'] is double){
        price = json['price'] ?? 0.0;
      }else{
        price = double.parse(("${json['price']}") ?? "0.0");
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class CartItems2 {
  String? cartid;
  String? pid;
  String? qty;
  String? pname;
  num? product_price;
  String? pimage;
  List<Addons>? addons;
  int? addonTotal;

  CartItems2(
      {this.cartid,
        this.pid,
        this.qty,
        this.product_price,
        this.addons,
        this.pname,
        this.pimage,
        this.addonTotal,});

  CartItems2.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    pid = json['pid'];
    qty = json['qty'];
    if(json['product_price'] != null){
      if(json['product_price'] is double){
        product_price = json['product_price'] ?? 0.0;
      }else{
        product_price = json['product_price'].toDouble();
      }
    }
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(new Addons.fromJson(v));
      });
    }
    //product_price = json['product_price'] is double ?json['product_price'];
    pname = json['pname'];
    pimage = json['pimage'];
    addonTotal = json['addon_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = this.cartid;
    data['pid'] = this.pid;
    data['qty'] = this.qty;
    data['product_price'] = this.product_price;
    if (this.addons != null) {
      data['addons'] = this.addons!.map((v) => v.toJson()).toList();
    }
    data['pname'] = this.pname;
    data['pimage'] = this.pimage;
    data['addon_total'] = this.addonTotal;
    return data;
  }
}