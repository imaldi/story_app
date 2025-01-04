import 'package:flutter/material.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoryListProvider extends ChangeNotifier {

  final ApiServices _apiServices;

  StoryListProvider(
      this._apiServices,
      );

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;

  Future<void> fetchStoryList() async {
    try {
      _resultState = StoryListLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryList();

      if (result?.error ?? false) {
        _resultState = StoryListErrorState(result.message ?? "");
        notifyListeners();
      } else {
        _resultState = StoryListLoadedState(result.listStory ?? []);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }
}