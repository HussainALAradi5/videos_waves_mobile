import '../../common/json_map.dart';

class ReactionCount {
  const ReactionCount({required this.emoji, required this.count});

  factory ReactionCount.fromJson(JsonMap json) => ReactionCount(emoji: json['emoji'] as String, count: json['count'] as int);

  final String emoji;
  final int count;
}
