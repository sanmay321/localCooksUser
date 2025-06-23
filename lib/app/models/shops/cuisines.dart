import 'package:artools/artools.dart';

class Cuisines{

  int? CuID;
  int? sid;
  int? is_displayed;
  String? CuName;

  Cuisines({this.CuID, this.sid, this.is_displayed, this.CuName});

  factory Cuisines.fromJson(JsonMap json) {
    return Cuisines(
      CuID: Model.intFromJson(json, "CuID"),
      sid: Model.intFromJson(json, "sid"),
      is_displayed: Model.intFromJson(json, "is_displayed"),
      CuName: Model.stringFromJson(json, "CuName"),
    );
  }

  JsonMap toJson() {
    return {
      "CuID" : CuID,
      "sid" : sid,
      "is_displayed" : is_displayed,
      "CuName" : CuName
    };
  }

  @override
  String toString() {
    return 'Shops{'
        "sid: $sid,"
        "CuID: $CuID,"
        "is_displayed: $is_displayed,"
        "CuName: $CuName"
        '}';
  }

}