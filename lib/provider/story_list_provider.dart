import 'package:flutter/material.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/static/add_story_result_state.dart';
import 'package:story_app/static/story_detail_result_state.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoryListProvider extends ChangeNotifier {

  final StoryApiServices _apiServices;

  StoryListProvider(
      this._apiServices,
      );

  StoryListResultState _resultListState = StoryListNoneState();

  StoryListResultState get resultListState => _resultListState;

  Future<void> fetchStoryList() async {
    try {
      _resultListState = StoryListLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryList();

      if (result?.error ?? false) {
        _resultListState = StoryListErrorState(result.message ?? "");
        notifyListeners();
      } else {
        _resultListState = StoryListLoadedState(result.listStory ?? []);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultListState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }

}