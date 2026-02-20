import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_response.freezed.dart';
part 'story_response.g.dart';

@freezed
abstract class StoryListResponse with _$StoryListResponse {
  const factory StoryListResponse({
    bool? error,
    String? message,
    @JsonKey(name: 'listStory') List<Story>? listStory,
  }) = _StoryListResponse;

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryListResponseFromJson(json);
}

@freezed
abstract class StoryDetailResponse with _$StoryDetailResponse {
  const factory StoryDetailResponse({
    bool? error,
    String? message,
    @JsonKey(name: 'story') Story? story,
  }) = _StoryDetailResponse;

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);
}

@freezed
abstract class Story with _$Story {
  const factory Story({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    double? lat,
    double? lon,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) =>
      _$StoryFromJson(json);
}
