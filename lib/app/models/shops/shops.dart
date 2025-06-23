import 'package:artools/artools.dart';

import 'cuisines.dart';

class Shops extends Model{

  int? sid;
  int? lid;
  String? sname;
  String? saddress;
  String? simage;
  String? banner;
  String? famous;
  String? email;
  String? commission;
  String? lat;
  String? slong;
  String? status;
  int? approve;
  String? description;
  String? chefs_image;
  String? sowner;
  String? slug;
  int accept_preorders = 0;
  int avgRating = 0;
  int totalReviews = 0;
  List<Cuisines>? cuisines;

  Shops({
    this.sid,
    this.lid,
    this.sname,
    this.saddress,
    this.simage,
    this.banner,
    this.famous,
    this.email,
    this.commission,
    this.lat,
    this.slong,
    this.status,
    this.approve,
    this.description,
    this.chefs_image,
    this.sowner,
    this.slug,
    this.accept_preorders = 0,
    this.avgRating = 0,
    this.totalReviews = 0,
    this.cuisines
  });

  factory Shops.fromJson(JsonMap json) {
    return Shops(
      sid: Model.intFromJson(json, 'sid'),
      lid: Model.intFromJson(json, 'lid'),
      sname: Model.stringFromJson(json, 'sname'),
      saddress: Model.stringFromJson(json, 'saddress'),
      simage: Model.stringFromJson(json, 'simage'),
      famous: Model.stringFromJson(json, 'famous'),
      email: Model.stringFromJson(json, 'email'),
      commission: Model.stringFromJson(json, 'commission'),
      lat: Model.stringFromJson(json, 'lat'),
      slong: Model.stringFromJson(json, 'slong'),
      status: Model.stringFromJson(json, 'status'),
      approve: Model.intFromJson(json, 'approve'),
      description: Model.stringFromJson(json, 'description'),
      chefs_image: Model.stringFromJson(json, 'chefs_image'),
      sowner: Model.stringFromJson(json, 'sowner'),
      slug: Model.stringFromJson(json, 'slug'),
      accept_preorders: Model.intFromJson(json, 'accept_preorders') ?? 0,
      avgRating: Model.intFromJson(json, 'avgRating') ?? 0,
      totalReviews: Model.intFromJson(json, 'totalReviews') ?? 0,
      cuisines: Model.listFromJson(json, 'cuisines', (c) => Cuisines.fromJson(c)) ?? [],
    );
  }

  JsonMap toJson() {
    return {
      "sid": sid,
      "lid": lid,
      "sname": sname,
      "saddress": saddress,
      "simage": simage,
      "banner": banner,
      "famous": famous,
      "email": email,
      "commission": commission,
      "lat": lat,
      "slong": slong,
      "status":status,
      "approve": approve,
      "description": description,
      "chefs_image": chefs_image,
      "sowner": sowner,
      "slug": slug,
      "accept_preorders": accept_preorders,
      "avgRating": avgRating,
      "totalReviews": totalReviews,
      "cuisines" : cuisines
    };
  }

  @override
  String toString() {
    return 'Shops{'
        "sid: $sid,"
        "lid: $lid,"
        "sname: $sname,"
        "saddress: $saddress,"
        "simage: $simage,"
        "banner: $banner,"
        "famous: $famous,"
        "email: $email,"
        "commission: $commission,"
        "lat: $lat,"
        "slong: $slong,"
        "status: $status,"
        "approve: $approve,"
        "description: $description,"
        "chefs_image: $chefs_image,"
        "sowner: $sowner,"
        "slug: $slug,"
        "accept_preorders: $accept_preorders,"
        "totalReviews: $totalReviews,"
        "avgRating: $avgRating,"
        "cuisines: ${cuisines.toString()}"
        '}';
  }

}