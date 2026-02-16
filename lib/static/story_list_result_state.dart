import 'package:story_app/model/story_response.dart';

/// mayvbe perlu freezed?
sealed class StoryListResultState {}

class StoryListNoneState extends StoryListResultState {}

class StoryListLoadingState extends StoryListResultState {}

class StoryListErrorState extends StoryListResultState {
  final String error;

  StoryListErrorState(this.error);
}

class StoryListLoadedState extends StoryListResultState {
  final List<Story> data;

  StoryListLoadedState(this.data);
}