class AddonsModel {
  int? status;
  List<AddonsData>? data;
  String? message;

  AddonsModel({this.status, this.data, this.message});

  AddonsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AddonsData>[];
      json['data'].forEach((v) {
        data!.add(new AddonsData.fromJson(v));
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

class AddonsData {
  int? addonId;
  int? pid;
  int? sid;
  String? addonName;
  String? addonPrice;
  String? addonStatus;
  int? groupId;
  int? available;
  bool? selected;

  AddonsData(
      {this.addonId,
        this.pid,
        this.sid,
        this.addonName,
        this.addonPrice,
        this.addonStatus,
        this.groupId,
        this.selected,
        this.available});

  AddonsData.fromJson(Map<String, dynamic> json) {
    addonId = json['addon_id'];
    pid = json['pid'];
    sid = json['sid'];
    addonName = json['addon_name'];
    addonPrice = json['addon_price'];
    addonStatus = json['addon_status'];
    groupId = json['group_id'];
    selected = json['selected'] ?? false;
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_id'] = this.addonId;
    data['pid'] = this.pid;
    data['sid'] = this.sid;
    data['addon_name'] = this.addonName;
    data['addon_price'] = this.addonPrice;
    data['addon_status'] = this.addonStatus;
    data['group_id'] = this.groupId;
    data['available'] = this.available;
    data['selected'] = this.selected;
    return data;
  }
}