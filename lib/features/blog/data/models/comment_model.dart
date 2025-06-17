import 'package:sblog/features/auth/data/models/user_model.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';

class CommentModel {
  final int id;
  final UserModel user;
  final int postId;
  final String content;
  final DateTime createdAt;
  final List<CommentModel> replies;
  final int likesCount;
  final bool isLiked;

  CommentModel({
    required this.id,
    required this.user,
    required this.postId,
    required this.content,
    required this.createdAt,
    this.replies = const [],
    this.likesCount = 0,
    this.isLiked = false,
  });

  /// Chuyển từ JSON sang `CommentModel`
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      user: UserModel.fromJson(json['user']),
      postId: json['post'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) =>
                  CommentModel.fromJson(reply as Map<String, dynamic>))
              .toList() ??
          [],
      likesCount: json['likes_count'] as int,
      isLiked: json['is_liked'] as bool,
    );
  }

  /// Chuyển từ `CommentModel` sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'post': postId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'likes_count': likesCount,
      'is_liked': isLiked,
    };
  }

  /// Chuyển từ `CommentModel` sang `Comment`
  Comment toEntity() {
    return Comment(
      id: id,
      user: user.toEntity(),
      postId: postId,
      content: content,
      createdAt: createdAt,
      replies: replies.map((reply) => reply.toEntity()).toList(),
      likesCount: likesCount,
      isLiked: isLiked,
    );
  }
}
