import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/core/consts/consts.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/model/user.dart';
import 'package:http/http.dart' as http;

class AuthApiServices {
  Future<bool> register(User user) async {
    try{
      var body = {
        "name": user.name,
        "email": user.email,
        "password": user.password
      };
      final response = await http.post(
        Uri.https(baseUrl, "$v1Path/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body)
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print("Error Register: $e");
      rethrow;
    }
  }
  Future<User> login(User user) async {
    try{
      var body = {
        "email": user.email,
        "password": user.password
      };
      final response = await http.post(
        Uri.https(baseUrl,"$v1Path/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body)
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body)).loginResult ?? User();
      } else {
        throw Exception('Failed to load restaurant list');
      }
    } catch (e) {
      print("Error getting list of stories: $e");
      rethrow;
    }
  }
}