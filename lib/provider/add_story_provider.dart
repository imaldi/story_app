import 'package:flutter/material.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/static/add_story_result_state.dart';

class AddStoryProvider extends ChangeNotifier {
  final StoryApiServices _apiServices;

  AddStoryProvider(
    this._apiServices,
  );

  AddStoryResultState _addStoryResultState = AddStoryNoneState();

  AddStoryResultState get addStoryResultState => _addStoryResultState;

  bool isLoadingAddStory = false;

  Future<bool> addStory(Story story) async {
    try {
      _addStoryResultState = AddStoryLoadingState();
      notifyListeners();

      final result = await _apiServices.addNewStory(
          description: story.description ?? "",
          photoPath: story.photoUrl ?? "");

      if (!result) {
        _addStoryResultState = AddStoryErrorState("Failed add story");
        notifyListeners();
        return false;
      } else {
        _addStoryResultState = AddStorySuccessState();
        notifyListeners();
        return result;
      }
    } on Exception catch (e) {
      _addStoryResultState = AddStoryErrorState(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> addStoryAsGuest(Story story) async {
    try {
      _addStoryResultState = AddStoryLoadingState();
      notifyListeners();

      final result = await _apiServices.addNewStory(
          description: story.description ?? "",
          photoPath: story.photoUrl ?? "");

      if (!result) {
        _addStoryResultState = AddStoryErrorState("Failed Add Story");
        notifyListeners();
        return false;
      } else {
        _addStoryResultState = AddStorySuccessState();
        notifyListeners();
        return result;
      }
    } on Exception catch (e) {
      _addStoryResultState = AddStoryErrorState(e.toString());
      notifyListeners();
      return false;
    }
  }
}
