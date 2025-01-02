import 'dart:convert';

class StoryDummy {
  final String id;
  final String content;
  final String author;

  StoryDummy({
    required this.id,
    required this.content,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
    };
  }

  factory StoryDummy.fromMap(Map<String, dynamic> map) {
    return StoryDummy(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryDummy.fromJson(String source) => StoryDummy.fromMap(json.decode(source));

  @override
  String toString() => 'Quote(id: $id, content: $content, author: $author)';
}

final stories = [
  StoryDummy(
    id: "1",
    content:
    "Cleaning code does NOT take time. NOT cleaning code does take time.",
    author: "Robert C. Martin",
  ),
  StoryDummy(
    id: "2",
    content: "Debugging time increases as a square of the program's size.",
    author: "Chris Wenham",
  ),
  StoryDummy(
    id: "3",
    content: "Adding manpower to a late software project makes it later.",
    author: "Edsger W. Dijkstra",
  ),
  StoryDummy(
    id: "4",
    content: "Deleted code is debugged code.",
    author: "Jeff Sickel",
  ),
  StoryDummy(
    id: "5",
    content:
    "A program that produces incorrect results twice as fast is infinitely slower.",
    author: "John Ousterhout",
  ),
];