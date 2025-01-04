import 'package:story_app/model/story_response.dart';

sealed class AddStoryResultState {}

class AddStoryNoneState extends AddStoryResultState {}

class AddStoryLoadingState extends AddStoryResultState {}

class AddStoryErrorState extends AddStoryResultState {
  final String error;

  AddStoryErrorState(this.error);
}

class AddStorySuccessState extends AddStoryResultState {}