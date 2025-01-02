import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/core/consts/consts.dart';
import 'package:story_app/model/story_response.dart';

class ApiServices {
  Future<List<Story>> getStoryList() async {
    final response = await http.get(Uri.parse("$baseUrl/list"));

    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(jsonDecode(response.body)).listStory ?? [];
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<Story> getStoryDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.body)).story ?? Story();
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
