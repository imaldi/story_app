import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/screen/body_of_detail_screen_widget.dart';
import 'package:story_app/static/story_detail_result_state.dart';

import '../model/story.dart';

class StoryDetailsScreen extends StatelessWidget {
  final String storyId;

  const StoryDetailsScreen({
    super.key,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context) {
    final story = stories.singleWhere((element) => element.id == storyId);
    return Scaffold(
      appBar: AppBar(
        title: Text(story.author),
      ),
      body: Consumer<StoryDetailProvider>(
        builder: (context, value, child) {

          return switch (value.resultDetailState) {
            StoryDetailLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            StoryDetailLoadedState(data: var story) =>
                BodyOfDetailScreenWidget(story: story),
            StoryDetailErrorState(error: var message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
