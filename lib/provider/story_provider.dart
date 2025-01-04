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
  StoryDetailResultState _resultDetailState = StoryDetailNoneState();
  AddStoryResultState _addStoryResultState = AddStoryNoneState();

  StoryListResultState get resultListState => _resultListState;
  StoryDetailResultState get resultDetailState => _resultDetailState;
  AddStoryResultState get addStoryResultState => _addStoryResultState;

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

  Future<void> fetchStoryDetail(String id) async {
    try {
      _resultDetailState = StoryDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryDetail(id);

      if (result?.error ?? false) {
        _resultDetailState = StoryDetailErrorState(result.message ?? "");
        notifyListeners();
      } else {
        _resultDetailState = StoryDetailLoadedState(result.story ?? Story());
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultDetailState = StoryDetailErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> addStory(Story story) async {
    try {
      _addStoryResultState = AddStoryLoadingState();
      notifyListeners();

      final result = await _apiServices.addNewStory(description: story.description ?? "", photoPath: story.photoUrl ?? "") ;

      if (result?.error ?? false) {
        _addStoryResultState = AddStoryErrorState(result?.message ?? "");
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

      if (result?.error ?? false) {
        _addStoryResultState = AddStoryErrorState(result?.message ?? "");
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