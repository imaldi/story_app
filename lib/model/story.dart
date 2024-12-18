import 'dart:convert';

class Story {
  final String id;
  final String content;
  final String author;

  Story({
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

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() => 'Quote(id: $id, content: $content, author: $author)';
}

final stories = [
  Story(
    id: "1",
    content:
    "Cleaning code does NOT take time. NOT cleaning code does take time.",
    author: "Robert C. Martin",
  ),
  Story(
    id: "2",
    content: "Debugging time increases as a square of the program's size.",
    author: "Chris Wenham",
  ),
  Story(
    id: "3",
    content: "Adding manpower to a late software project makes it later.",
    author: "Edsger W. Dijkstra",
  ),
  Story(
    id: "4",
    content: "Deleted code is debugged code.",
    author: "Jeff Sickel",
  ),
  Story(
    id: "5",
    content:
    "A program that produces incorrect results twice as fast is infinitely slower.",
    author: "John Ousterhout",
  ),
];