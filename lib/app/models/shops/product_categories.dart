class ProductCategories {
  int? status;
  List<ProductCategoriesData>? data;
  String? message;

  ProductCategories({this.status, this.data, this.message});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ProductCategoriesData>[];
      json['data'].forEach((v) {
        data!.add(new ProductCategoriesData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ProductCategoriesData {
  int? cid;
  int? sid;
  String? cname;
  String? cimage;
  List<Products>? products;

  ProductCategoriesData({this.cid, this.sid, this.cname, this.cimage, this.products});

  ProductCategoriesData.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    sid = json['sid'];
    cname = json['cname'];
    cimage = json['cimage'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['sid'] = this.sid;
    data['cname'] = this.cname;
    data['cimage'] = this.cimage;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? pid;
  int? cid;
  int? sid;
  String? pname;
  String? punit;
  String? price;
  String? mrp;
  String? pdesc;
  String? pimage;
  int? status;
  int? maxAddons;
  int? minAddons;
  //Null? addonGroups;
  int? addonGroupId;

  Products(
      {this.pid,
        this.cid,
        this.sid,
        this.pname,
        this.punit,
        this.price,
        this.mrp,
        this.pdesc,
        this.pimage,
        this.status,
        this.maxAddons,
        this.minAddons,
        //this.addonGroups,
        this.addonGroupId
      });

  Products.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    cid = json['cid'];
    sid = json['sid'];
    pname = json['pname'];
    punit = json['punit'];
    price = json['price'];
    mrp = json['mrp'];
    pdesc = json['pdesc'];
    pimage = json['pimage'];
    status = json['status'];
    maxAddons = json['max_addons'] ?? 0;
    minAddons = json['min_addons'] ?? 0;
    //addonGroups = json['addon_groups'];
    addonGroupId = json['addon_group_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['cid'] = this.cid;
    data['sid'] = this.sid;
    data['pname'] = this.pname;
    data['punit'] = this.punit;
    data['price'] = this.price;
    data['mrp'] = this.mrp;
    data['pdesc'] = this.pdesc;
    data['pimage'] = this.pimage;
    data['status'] = this.status;
    data['max_addons'] = this.maxAddons;
    data['min_addons'] = this.minAddons;
    //data['addon_groups'] = this.addonGroups;
    data['addon_group_id'] = this.addonGroupId;
    return data;
  }
}