import '../../common/json_map.dart';

class VideoLikeState {
  const VideoLikeState({required this.videoId, required this.isLiked, required this.likesCount});

  factory VideoLikeState.fromJson(JsonMap json) => VideoLikeState(
        videoId: json['videoId'] as String,
        isLiked: json['isLiked'] as bool,
        likesCount: json['likesCount'] as int,
      );

  final String videoId;
  final bool isLiked;
  final int likesCount;
}
