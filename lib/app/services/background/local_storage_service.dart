import 'dart:convert';

import 'package:get/get.dart';
import 'package:localcooks_app/app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class LocalStorageService extends GetxService {
  late SharedPreferences prefs;

  Future<LocalStorageService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<UserModel> getUserFromStorage() async {
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    } else {
      return UserModel(token: null, message: "");
    }
  }

  Future<void> removeCurrentUserFromStorage() async {
    await prefs.remove('current_user');
  }

  Future<void> removeProfileFromStorage() async {
    await prefs.remove('current_user_profile');
  }

  Future<void> saveUserToStorage(UserModel user) async {
    await prefs.setString('current_user', jsonEncode(user.toJson()));
  }

  Future<Profile?> getUserProfileFromStorage() async {
    final userJson = prefs.getString('current_user_profile');
    if (userJson != null) {
      return Profile.fromJson(jsonDecode(userJson));
    } else {
      return null;
    }
  }

  Future<void> saveProfileToStorage(Profile user) async {
    await prefs.setString('current_user_profile', jsonEncode(user.toJson()));
  }

  Future<void> saveToken(String token) async {
    await prefs.setString('fcm_token', token);
  }

  Future<String?> getToken() async {
    final token = prefs.getString('fcm_token');
    return token;
  }

  Future<void> removeToken() async {
    await prefs.remove('fcm_token');
  }
}
