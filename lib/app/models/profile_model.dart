import 'package:artools/artools.dart';
import 'package:localcooks_app/app/models/profile.dart';

class ProfileModel extends Model{

  String? message;
  int? status;
  List<Profile>? data;

  ProfileModel({
    this.status,
    this.message,
    this.data
  });

  factory ProfileModel.fromJson(JsonMap json) {
    return ProfileModel(
      status: Model.intFromJson(json, 'status'),
      message: Model.stringFromJson(json, 'message'),
      data: Model.listFromJson(json, "data", (profile) => Profile.fromJson(profile)),
    );
  }

  JsonMap toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ProfileModel{'
        'status: $status, '
        'message: $message, '
        '}';
  }

}