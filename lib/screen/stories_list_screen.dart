import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoriesListScreen extends StatefulWidget {
  final List<StoryDummy> stories;
  final Function(String, String) onTapped;
  final Function() onFabTapped;

  const StoriesListScreen({
    Key? key,
    required this.stories,
    required this.onTapped,
    required this.onFabTapped,
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
    return Consumer<StoryListProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Story App"),
          ),
          body: switch (value.resultListState) {
            StoryListLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            StoryListLoadedState(data: var storyList) => RefreshIndicator(
              onRefresh: () async {
                await context.read<StoryListProvider>().fetchStoryList();
              },
              child: ListView(
                  children: [
                    for (var story in storyList)
                      ListTile(
                        title: Text(story.name ?? ""),
                        subtitle: Text(story.description ?? ""),
                        isThreeLine: true,
                        onTap: () => widget.onTapped(story.id ?? "", story.photoUrl ?? ''),
                      )
                  ],
                ),
            ),
            StoryListErrorState(error: var message) => Center(
                child: Text(message),
              ),
            _ => const SizedBox(),
          },
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add), onPressed: widget.onFabTapped),
        );
      },
    );
  }
}
