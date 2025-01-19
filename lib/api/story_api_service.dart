import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/core/consts/consts.dart';
import 'package:story_app/model/story_response.dart';

class StoryApiServices {
  Future<StoryListResponse> getStoryList() async {
    try {
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception("Authentication token is missing");
      }

      final response = await http.get(
        Uri.https(baseUrl, "$v1Path/stories"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Status List: ${response.statusCode}");
      print("Body List: ${response.body}");

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

  Future<StoryDetailResponse> getStoryDetail(String id) async {
    try {
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception("Authentication token is missing");
      }

      final response = await http.get(
        Uri.https(baseUrl, "$v1Path/stories/$id"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Status List: ${response.statusCode}");
      print("Body List: ${response.body}");

      if (response.statusCode == 200) {
        return StoryDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      print("Error getting detail story: $e");
      rethrow;
    }
  }

  Future<bool> addNewStory({
    required String description,
    // TODO nanti akalin gimana bisa dapat filenya dari sini
    required String photoPath,
    double? lat,
    double? lon,
  }) async {
    final String endpoint = "https://$baseUrl$v1Path/stories";

    try {
      // Get Bearer Token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      // Check is photo file exist to upload
      final file = File(photoPath);

      // Ensure the file exists
      if (!file.existsSync()) {
        throw Exception('File does not exist at path: $photoPath');
      }

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
          photoPath,
          filename: photoPath.split('/').last,
        ),
      );

      // Send request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Story uploaded successfully");
        return true;
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
    required String photoPath,
    double? lat,
    double? lon,
  }) async {
    final String endpoint = "https://$baseUrl$v1Path/stories/guest";

    try {
      // Create Multipart Request
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Check is photo file exist to upload
      final file = File(photoPath);

      // Ensure the file exists
      if (!file.existsSync()) {
        throw Exception('File does not exist at path: $photoPath');
      }

      // Add fields to request
      request.fields['description'] = description;

      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photoPath,
          filename: photoPath.split('/').last,
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
