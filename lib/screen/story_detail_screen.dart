import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/screen/body_of_detail_screen_widget.dart';
import 'package:story_app/static/story_detail_result_state.dart';

import '../model/story.dart';

class StoryDetailsScreen extends StatefulWidget {
  final String storyId;
  final String? storyImageUrl;

  const StoryDetailsScreen({
    super.key,
    required this.storyId,
    this.storyImageUrl
  });

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<StoryDetailProvider>().fetchStoryDetail(widget.storyId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final story = stories.singleWhere((element) => element.id == widget.storyId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Detail'),
      ),
      body: Consumer<StoryDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultDetailState) {
            StoryDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            StoryDetailLoadedState(data: var story) =>
              BodyOfDetailScreenWidget(story: story.copyWith(photoUrl: story.photoUrl ?? widget.storyImageUrl)),
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
