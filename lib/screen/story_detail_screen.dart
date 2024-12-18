import 'package:flutter/material.dart';

import '../model/story.dart';

class StoryDetailsScreen extends StatelessWidget {
  final String storyId;

  const StoryDetailsScreen({
    Key? key,
    required this.storyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final story = stories.singleWhere((element) => element.id == storyId);
    return Scaffold(
      appBar: AppBar(
        title: Text(story.author),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(story.author, style: Theme.of(context).textTheme.titleSmall),
            Text(story.content, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}