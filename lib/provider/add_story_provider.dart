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


  Future<void> addStory(Story story) async {
    try {
      _addStoryResultState = AddStoryLoadingState();
      notifyListeners();

      final result = await _apiServices.addNewStory(description: story.description ?? "", photoPath: story.photoUrl ?? "") ;

      if (result.error ?? false) {
        _addStoryResultState = AddStoryErrorState(result.message ?? "");
        notifyListeners();
      } else {
        _addStoryResultState = AddStorySuccessState();
        notifyListeners();
      }
    } on Exception catch (e) {
      _addStoryResultState = AddStoryErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> addStoryAsGuest(Story story) async {
    try {
      _addStoryResultState = AddStoryLoadingState();
      notifyListeners();

      final result = await _apiServices.addNewStory(description: story.description ?? "", photoPath: story.photoUrl ?? "") ;

      if (result.error ?? false) {
        _addStoryResultState = AddStoryErrorState(result.message ?? "");
        notifyListeners();
      } else {
        _addStoryResultState = AddStorySuccessState();
        notifyListeners();
      }
    } on Exception catch (e) {
      _addStoryResultState = AddStoryErrorState(e.toString());
      notifyListeners();
    }
  }
}