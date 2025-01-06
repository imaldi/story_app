import 'package:flutter/material.dart';
import 'package:story_app/model/story_response.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              story.photoUrl ?? "",
              fit: BoxFit.cover,
            ),
            const SizedBox.square(dimension: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.name ?? "",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        story.createdAt.toString() ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.favorite,
                //       color: Colors.pink,
                //     ),
                //     const SizedBox.square(dimension: 4),
                //     Text(
                //       story.like.toString(),
                //       style: Theme.of(context).textTheme.bodyLarge,
                //     )
                //   ],
                // ),
              ],
            ),
            const SizedBox.square(dimension: 16),
            Text(
              story.description ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}