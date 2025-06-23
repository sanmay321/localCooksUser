import 'package:artools/artools.dart';

class UserModel extends Model{
  String? token;
  String? message;

  UserModel({
    this.token,
    this.message,
  });

  factory UserModel.fromJson(JsonMap json) {
    return UserModel(
      token: Model.stringFromJson(json, 'token'),
      message: Model.stringFromJson(json, 'message'),
    );
  }

  JsonMap toJson() {
    return {
      'token': token,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'UserModel{'
        'token: $token, '
        'message: $message, '
        '}';
  }
}