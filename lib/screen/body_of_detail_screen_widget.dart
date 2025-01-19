import 'package:flutter/material.dart';
import 'package:story_app/model/story_response.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  @override
  void initState() {
    print("Image Url: ${widget.story.photoUrl}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(
                    widget.story.photoUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stacTrace) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image),
                            Text("The image is not found"),
                          ]);
                    },
                  ),
                ),
              ),
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
                        widget.story.name ?? "",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        ("Created at: ${widget.story.createdAt ?? '-'}")
                            .toString(),
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
              widget.story.description ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
