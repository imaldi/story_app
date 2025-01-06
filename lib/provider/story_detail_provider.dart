import 'package:flutter/material.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/static/story_detail_result_state.dart';

class StoryDetailProvider extends ChangeNotifier {
  final StoryApiServices _apiServices;

  StoryDetailProvider(
      this._apiServices,
      );

  StoryDetailResultState _resultDetailState = StoryDetailNoneState();

  StoryDetailResultState get resultDetailState => _resultDetailState;


  Future<void> fetchStoryDetail(String id) async {
    try {
      _resultDetailState = StoryDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryDetail(id);

      if (result?.error ?? false) {
        _resultDetailState = StoryDetailErrorState(result.message ?? "");
        notifyListeners();
      } else {
        print("story detail result: ${result.story}");
        _resultDetailState = StoryDetailLoadedState(result.story ?? Story());
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultDetailState = StoryDetailErrorState(e.toString());
      notifyListeners();
    }
  }


}