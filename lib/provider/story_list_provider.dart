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

  StoryListResultState _state = StoryListNoneState();
  StoryListResultState get state => _state;

  Future<void> fetchStoryList({
    int page = 1,
    int size = 10,
    bool isRefresh = false,
    bool isLocation = false,
  }) async {
    try {
      if (isRefresh) {
        _state = StoryListInitialLoading();
        notifyListeners();
      } else {
        if (_state is StoryListLoaded) {
          _state = (_state as StoryListLoaded).copyWith(isLoadingMore: true);
          notifyListeners();
        }
      }

      final result = await _apiServices.getStoryList(
        page: page,
        size: size,
        isLocation: isLocation,
      );

      if (result.error ?? false) {
        _state = StoryListError(result.message ?? "Gagal memuat");
      } else {
        List<Story> currentList = [];
        bool reachedEnd = false;

        if (_state is StoryListLoaded) {
          currentList = List.from((_state as StoryListLoaded).data);
        }

        final newStories = result.listStory ?? [];
        if (newStories.length % 10 != 0) {
          reachedEnd = true;
        } else {
          // Hindari duplikat berdasarkan id
          for (var story in newStories) {
            if (!currentList.any((s) => s.id == story.id)) {
              currentList.add(story);
            }
          }
        }

        _state = StoryListLoaded(
          data: currentList,
          isLoadingMore: false,
          hasReachedEnd: reachedEnd,
        );
      }
    } catch (e) {
      _state = StoryListError(e.toString());
    }
    notifyListeners();
  }

  // Method refresh
  Future<void> refresh() async {
    await fetchStoryList(page: 1, isRefresh: true);
  }
}