import 'package:sblog/features/auth/domain/entities/user.dart';

class Comment {
  final int id;
  final User user;
  final int postId;
  final String content;
  final DateTime createdAt;
  final List<Comment> replies;
  final int likesCount;
  final bool isLiked;

  Comment({
    required this.id,
    required this.user,
    required this.postId,
    required this.content,
    required this.createdAt,
    this.replies = const [],
    this.likesCount = 0,
    this.isLiked = false,
  });
}
