import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/api/auth_api_service.dart';
import 'package:story_app/core/consts/consts.dart';
import 'package:story_app/model/user.dart';

class AuthRepository {

  final AuthApiServices authApiServices;
  AuthRepository(this.authApiServices);

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }


  Future<bool> login(User user) async {
    try{
      // call auth service here
      var userResult = await authApiServices.login(user);

      final preferences = await SharedPreferences.getInstance();
      await Future.delayed(const Duration(seconds: 2));
      preferences.setString(userKey, jsonEncode(userResult.toJson()));
      preferences.setString(tokenKey, userResult.token ?? "");
      return preferences.setBool(stateKey, true);
    } catch(e) {
      throw Exception("Failure login: $e");
    }
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> register(User user) async {
    try{
      // call auth service here
      var successRegister = await authApiServices.register(user);
      if(successRegister) {
        return true;
      }
      return false;
    } catch(e) {
      throw Exception("Failure login: $e");
    }

  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.clear();
  }
  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(jsonDecode(json));
    } catch (e) {
      user = null;
    }
    return user;
  }


}