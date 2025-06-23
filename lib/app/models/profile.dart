import 'package:artools/artools.dart';

class Profile extends Model{

  String? userid;
  String? username;
  String? useraddress;
  String? useremail;
  String? userphone;
  String? city;
  String? userlandmark;
  String? latuser;
  String? longuser;
  String? addisset;

  Profile({this.userid, this.username, this.useraddress, this.useremail, this.userphone, this.city, this.userlandmark, this.latuser, this.longuser, this.addisset});

  factory Profile.fromJson(JsonMap json) {
    return Profile(
      userid: Model.stringFromJson(json, 'userid'),
      username: Model.stringFromJson(json, 'username'),
      useraddress: Model.stringFromJson(json, 'useraddress'),
      useremail: Model.stringFromJson(json, 'useremail'),
      userphone: Model.stringFromJson(json, 'userphone'),
      city: Model.stringFromJson(json, 'city'),
      userlandmark: Model.stringFromJson(json, 'userlandmark'),
      latuser: Model.stringFromJson(json, 'latuser'),
      longuser: Model.stringFromJson(json, 'longuser'),
      addisset: Model.stringFromJson(json, 'addisset'),
    );
  }

  JsonMap toJson() {
    return {
      'userid': userid,
      'username': username,
      'useraddress': useraddress,
      'useremail': useremail,
      'userphone': userphone,
      'city': city,
      'userlandmark': userlandmark,
      'latuser': latuser,
      'longuser': longuser,
      'addisset': addisset,
    };
  }

  @override
  String toString() {
    return 'Profile{'
        'userid: $userid, '
        'username: $username, '
        'useraddress: $useraddress, '
        'useremail: $useremail, '
        'userphone: $userphone, '
        'city: $city, '
        'userlandmark: $userlandmark, '
        'latuser: $latuser, '
        'longuser: $longuser, '
        'addisset: $addisset, '
        '}';
  }

}