import 'package:story_app/model/story_response.dart';

sealed class StoryListResultState {}

class StoryListNoneState extends StoryListResultState {}

class StoryListInitialLoading extends StoryListResultState {}

class StoryListLoaded extends StoryListResultState {
  final List<Story> data;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  StoryListLoaded({
    required this.data,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  StoryListLoaded copyWith({
    List<Story>? data,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return StoryListLoaded(
      data: data ?? this.data,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class StoryListError extends StoryListResultState {
  final String message;
  StoryListError(this.message);
}