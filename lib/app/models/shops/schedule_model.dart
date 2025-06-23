class Schedule {
  int? status;
  ScheduleData? data;
  String? message;

  Schedule({this.status, this.data, this.message});

  Schedule.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ScheduleData.fromJson(json['data']) : null;
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

class ScheduleData {
  Day? mon;
  Day? tue;
  Day? wed;
  Day? thu;
  Day? fri;
  Day? sat;
  Day? sun;

  ScheduleData({this.mon, this.tue, this.wed, this.thu, this.fri, this.sat, this.sun});

  ScheduleData.fromJson(Map<String, dynamic> json) {
    mon = json['Mon'] != null ? Day.fromJson(json['Mon']) : null;
    tue = json['Tue'] != null ? Day.fromJson(json['Tue']) : null;
    wed = json['Wed'] != null ? Day.fromJson(json['Wed']) : null;
    thu = json['Thu'] != null ? Day.fromJson(json['Thu']) : null;
    fri = json['Fri'] != null ? Day.fromJson(json['Fri']) : null;
    sat = json['Sat'] != null ? Day.fromJson(json['Sat']) : null;
    sun = json['Sun'] != null ? Day.fromJson(json['Sun']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.mon != null) {
      data['Mon'] = this.mon!.toJson();
    }
    if (this.tue != null) {
      data['Tue'] = this.tue!.toJson();
    }
    if (this.wed != null) {
      data['Wed'] = this.wed!.toJson();
    }
    if (this.thu != null) {
      data['Thu'] = this.thu!.toJson();
    }
    if (this.fri != null) {
      data['Fri'] = this.fri!.toJson();
    }
    if (this.sat != null) {
      data['Sat'] = this.sat!.toJson();
    }
    if (this.sun != null) {
      data['Sun'] = this.sun!.toJson();
    }
    return data;
  }
}

class Day {
  String? openTime;
  String? closeTime;
  int? isClosed;

  Day({this.openTime, this.closeTime, this.isClosed});

  Day.fromJson(Map<String, dynamic> json) {
    openTime = json['open_time'];
    closeTime = json['close_time'];
    isClosed = json['is_closed'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['is_closed'] = this.isClosed;
    return data;
  }
}