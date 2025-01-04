import 'package:story_app/model/story_response.dart';

sealed class StoryDetailResultState {}

class StoryDetailNoneState extends StoryDetailResultState {}

class StoryDetailLoadingState extends StoryDetailResultState {}

class StoryDetailErrorState extends StoryDetailResultState {
  final String error;

  StoryDetailErrorState(this.error);
}

class StoryDetailLoadedState extends StoryDetailResultState {
  final Story data;

  StoryDetailLoadedState(this.data);
}