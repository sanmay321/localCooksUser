class MyOrders {
  int? status;
  List<MyOrdersData>? data;
  String? message;

  MyOrders({this.status, this.data, this.message});

  MyOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MyOrdersData>[];
      json['data'].forEach((v) {
        data!.add(new MyOrdersData.fromJson(v));
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

class MyOrdersData {
  int? oid;
  int? lid;
  int? sid;
  int? userid;
  int? did;
  String? uname;
  String? ophone;
  String? pname;
  String? price;
  String? dcharge;
  int? dchargestatus;
  String? shopcharge;
  int? restrochargestatus;
  String? adminincome;
  String? rider;
  String? status;
  String? tid;
  String? tax;
  String? temp;
  String? orderAddress;
  String? ordertime;
  String? description;
  int? isSmsSent;
  String? addons;
  int? ready;
  String? tip;
  int? preoid;
  String? preordertime;
  bool? displayMore;
  bool? displayPrices;

  MyOrdersData(
      {this.oid,
        this.lid,
        this.sid,
        this.userid,
        this.did,
        this.uname,
        this.ophone,
        this.pname,
        this.price,
        this.dcharge,
        this.dchargestatus,
        this.shopcharge,
        this.restrochargestatus,
        this.adminincome,
        this.rider,
        this.status,
        this.tid,
        this.tax,
        this.temp,
        this.orderAddress,
        this.ordertime,
        this.description,
        this.isSmsSent,
        this.addons,
        this.ready,
        this.tip,
        this.preoid,
        this.preordertime,
        this.displayPrices,
      this.displayMore});

  MyOrdersData.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    lid = json['lid'];
    sid = json['sid'];
    displayMore = json['displayMore'] ?? false;
    displayPrices = json['displayPrices'] ?? false;
    userid = json['userid'];
    did = json['did'];
    uname = json['uname'];
    ophone = json['ophone'];
    pname = json['pname'];
    price = json['price'];
    dcharge = json['dcharge'];
    dchargestatus = json['dchargestatus'];
    shopcharge = json['shopcharge'];
    restrochargestatus = json['restrochargestatus'];
    adminincome = json['adminincome'];
    rider = json['rider'];
    status = json['status'];
    tid = json['tid'];
    tax = json['tax'];
    temp = json['temp'];
    orderAddress = json['orderAddress'];
    ordertime = json['ordertime'];
    description = json['description'];
    isSmsSent = json['is_sms_sent'];
    addons = json['addons'];
    ready = json['ready'];
    tip = json['tip'];
    preoid = json['preoid'];
    preordertime = json['preordertime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oid'] = this.oid;
    data['displayPrices'] = this.displayPrices;
    data['displayMore'] = this.displayMore;
    data['lid'] = this.lid;
    data['lid'] = this.lid;
    data['sid'] = this.sid;
    data['userid'] = this.userid;
    data['did'] = this.did;
    data['uname'] = this.uname;
    data['ophone'] = this.ophone;
    data['pname'] = this.pname;
    data['price'] = this.price;
    data['dcharge'] = this.dcharge;
    data['dchargestatus'] = this.dchargestatus;
    data['shopcharge'] = this.shopcharge;
    data['restrochargestatus'] = this.restrochargestatus;
    data['adminincome'] = this.adminincome;
    data['rider'] = this.rider;
    data['status'] = this.status;
    data['tid'] = this.tid;
    data['tax'] = this.tax;
    data['temp'] = this.temp;
    data['orderAddress'] = this.orderAddress;
    data['ordertime'] = this.ordertime;
    data['description'] = this.description;
    data['is_sms_sent'] = this.isSmsSent;
    data['addons'] = this.addons;
    data['ready'] = this.ready;
    data['tip'] = this.tip;
    data['preoid'] = this.preoid;
    data['preordertime'] = this.preordertime;
    return data;
  }
}