import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/core/consts/consts.dart';
import 'package:story_app/model/story_response.dart';

class ApiServices {
  Future<StoryListResponse> getStoryList() async {
    try{
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception("Authentication token is missing");
      }

      final response = await http.get(Uri.parse("$baseUrl/list"));

      if (response.statusCode == 200) {
        return StoryListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurant list');
      }
    } catch (e) {
      print("Error getting list of stories: $e");
      rethrow;
    }
  }

  Future<Story> getStoryDetail(String id) async {
    try{
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception("Authentication token is missing");
      }

      final response = await http.get(Uri.parse("$baseUrl/detail/$id",),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return StoryDetailResponse.fromJson(jsonDecode(response.body)).story ?? Story();
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      print("Error getting detail story: $e");
      rethrow;
    }
  }

  Future<void> addNewStory({
    required String description,
    required File photo,
    double? lat,
    double? lon,
  }) async {
    final String endpoint = "$baseUrl/stories";

    try {
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      // Create Multipart Request
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add Authorization Header
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields to request
      request.fields['description'] = description;

      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          filename: photo.path.split('/').last,
        ),
      );

      // Send request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Story uploaded successfully");
      } else {
        throw Exception('Failed to upload story: ${response.body}');
      }
    } catch (e) {
      print("Error uploading story: $e");
      rethrow;
    }
  }
  Future<void> addNewStoryAsGuest({
    required String description,
    required File photo,
    double? lat,
    double? lon,
  }) async {
    final String endpoint = "$baseUrl/stories/guest";

    try {
      // Create Multipart Request
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add fields to request
      request.fields['description'] = description;

      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          filename: photo.path.split('/').last,
        ),
      );

      // Send request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Story uploaded successfully");
      } else {
        throw Exception('Failed to upload story: ${response.body}');
      }
    } catch (e) {
      print("Error uploading story: $e");
      rethrow;
    }
  }
}
