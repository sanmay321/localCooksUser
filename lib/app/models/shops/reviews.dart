class Reviews {
  int? status;
  List<ReviewsData>? data;
  String? message;

  Reviews({this.status, this.data, this.message});

  Reviews.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ReviewsData>[];
      json['data'].forEach((v) {
        data!.add(new ReviewsData.fromJson(v));
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

class ReviewsData {
  int? rtid;
  int? oid;
  int? uid;
  int? sid;
  String? rating;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? lid;
  String? username;

  ReviewsData(
      {this.rtid,
        this.oid,
        this.uid,
        this.sid,
        this.rating,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.lid,
        this.username});

  ReviewsData.fromJson(Map<String, dynamic> json) {
    rtid = json['rtid'];
    oid = json['oid'];
    uid = json['uid'];
    sid = json['sid'];
    rating = json['rating'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lid = json['lid'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rtid'] = this.rtid;
    data['oid'] = this.oid;
    data['uid'] = this.uid;
    data['sid'] = this.sid;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['lid'] = this.lid;
    data['username'] = this.username;
    return data;
  }
}