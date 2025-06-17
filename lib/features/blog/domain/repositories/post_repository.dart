import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';

abstract class PostRepository {
  /// Lấy danh sách bài viết
  Future<Either<String, List<Post>>> getPosts(params);

  /// Lấy bài viết theo id
  Future<Either<String, List<Post>>> getPostById(String id, params);

  /// Lấy bài viết theo danh mục
  Future<Either<String, List<Post>>> getPostsByCategory(
      String categoryId, params);

  Future<Either<String, List<Post>>> getPostsLiked(params);

  /// thích bài viết
  Future<Either<String, String>> likePost(int postId);

  // tạo bài viết
  Future<Either<String, String>> createPost(
    String title,
    String subTitle,
    String content,
    String featuredImage,
    int categoryId,
  );

  Future<Either<String, String>> updatePost(
    int id,
    String title,
    String subTitle,
    String content,
    String featuredImage,
    int categoryId,
  );

  Future<Either<String, String>> uploadImage(File image);
  Future<void> deletePost(String postId);
}
