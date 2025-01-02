import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryListResponse extends Equatable {
  final bool? error;
  final String? message;
  @JsonKey(name: "listStory")
  final List<Story>? listStory;

  StoryListResponse({
    this.error,
    this.message,
    this.listStory,
  });

  StoryListResponse copyWith({
    bool? error,
    String? message,
    List<Story>? listStory,
  }) =>
      StoryListResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        listStory: listStory ?? this.listStory,
      );

  factory StoryListResponse.fromJson(Map<String, dynamic> json) => _$StoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryListResponseToJson(this);

  @override
  List<Object?> get props => [
    error,
    message,
    listStory
  ];
}

@JsonSerializable()
class StoryDetailResponse extends Equatable {
  final bool? error;
  final String? message;
  @JsonKey(name: "story")
  final Story? story;

  StoryDetailResponse({
    this.error,
    this.message,
    this.story,
  });

  StoryDetailResponse copyWith({
    bool? error,
    String? message,
    Story? story,
  }) =>
      StoryDetailResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        story: story ?? this.story,
      );

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) => _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);

  @override
  List<Object?> get props => [
    error,
    message,
    story
  ];
}

@JsonSerializable()
class Story extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  @JsonKey(name: "photo_url")
  final String? photoUrl;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  Story copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    DateTime? createdAt,
    double? lat,
    double? lon,
  }) =>
      Story(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        photoUrl: photoUrl ?? this.photoUrl,
        createdAt: createdAt ?? this.createdAt,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    photoUrl,
    createdAt,
    lat,
    lon,
  ];
}
