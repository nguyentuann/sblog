import 'dart:convert';

import 'package:sblog/features/blog/domain/entities/post.dart';

class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.content, // đây sẽ là Map<String, dynamic> lưu delta của quill
    required this.featuredImage,
    required this.createAt,
    required this.updateAt,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.authorId,
    required this.categoryId,
    required this.watchCount,
  });

  final int id;
  final String title;
  final String subTitle;
  final List<Map<String, dynamic>>
      content; // cập nhật content thành Map để parse delta quill
  final String featuredImage;
  final DateTime createAt;
  final DateTime updateAt;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final int authorId;
  final int categoryId;
  final int watchCount;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      subTitle: json['subtitle'] as String,
      content: List<Map<String, dynamic>>.from(
          (jsonDecode(json['content']) as Map<String, dynamic>)['ops']),
      featuredImage: json['featured_image'] as String,
      createAt: DateTime.parse(json['created_at']),
      updateAt: DateTime.parse(json['updated_at']),
      commentCount: json['comments_count'] as int,
      likeCount: json['likes_count'] as int,
      isLiked: json['is_liked'] as bool,
      authorId: json['author_id'] as int,
      categoryId: json['category'] as int,
      watchCount: json['watch_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subTitle,
      'content': jsonEncode(content), // serialize lại thành String JSON
      'featured_image': featuredImage,
      'created_at': createAt.toIso8601String(),
      'updated_at': updateAt.toIso8601String(),
      'comments_count': commentCount,
      'likes_count': likeCount,
      'is_liked': isLiked,
      'author_id': authorId,
      'category': categoryId, // giữ tên key như server trả về
      'watch_count': watchCount,
    };
  }

  Post toEntity() {
    return Post(
      id: id,
      title: title,
      subTitle: subTitle,
      content: content,
      featuredImage: featuredImage,
      createdAt: createAt,
      updatedAt: updateAt,
      commentCount: commentCount,
      likeCount: likeCount,
      isLiked: isLiked,
      authorId: authorId,
      categoryId: categoryId,
      watchCount: watchCount,
    );
  }
}
