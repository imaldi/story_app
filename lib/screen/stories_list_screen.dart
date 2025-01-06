import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoriesListScreen extends StatefulWidget {
  final List<StoryDummy> stories;
  final Function(String) onTapped;

  const StoriesListScreen({
    Key? key,
    required this.stories,
    required this.onTapped,
  }) : super(key: key);

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<StoryListProvider>().fetchStoryList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: Consumer<StoryListProvider>(
        builder: (context, value, child) {
          return switch (value.resultListState) {
            StoryListLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            StoryListLoadedState(data: var storyList) => ListView(
                children: [
                  for (var story in storyList)
                    ListTile(
                      title: Text(story.name ?? ""),
                      subtitle: Text(story.description ?? ""),
                      isThreeLine: true,
                      onTap: () => widget.onTapped(story.id ?? ""),
                    )
                ],
              ),
            StoryListErrorState(error: var message) => Center(
                child: Text(message),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
