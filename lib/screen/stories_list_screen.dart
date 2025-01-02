import 'package:flutter/material.dart';
import 'package:story_app/model/story.dart';


class StoriesListScreen extends StatelessWidget {
  final List<StoryDummy> stories;
  final Function(String) onTapped;

  const StoriesListScreen({
    Key? key,
    required this.stories,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: ListView(
        children: [
          for (var quote in stories)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.content),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            )
        ],
      ),
    );
  }
}