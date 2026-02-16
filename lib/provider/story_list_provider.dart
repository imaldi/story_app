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

  Future<void> fetchStoryList({
      int? page,
      int? size,
      bool? isLocation = false,
  }) async {
    try {
      final List<Story> oldList = switch(_resultListState){
        StoryListNoneState() => [],
        StoryListLoadingState() => [],
        StoryListErrorState() => [],
        StoryListLoadedState(data: final data) => [...data],
      };
      _resultListState = StoryListLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryList(
        page: page,
        size: size,
        isLocation: isLocation,
      );

      if (result.error ?? false) {
        _resultListState = StoryListErrorState(result.message ?? "");
        notifyListeners();
      } else {
        for (final item in (result.listStory ?? [])) {
          if (!oldList.contains(item.id)) {
            oldList.add(item);
          }
        }
        _resultListState = StoryListLoadedState(oldList);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultListState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }

}