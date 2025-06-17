import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/data/models/post_model.dart';
import 'package:sblog/features/blog/data/sources/api/post_api.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostRepositoryImpl implements PostRepository {
  final postAPI = sl<PostAPI>();
  Future<Either<String, List<Post>>> _fetchPosts(
      Future<Either<String, List<PostModel>>> Function() apiCall) async {
    try {
      final response = await apiCall(); // Gọi API được truyền vào
      return response.fold(
        (l) => Left(l),
        (r) {
          final posts = r.map((e) => e.toEntity()).toList();
          return Right(posts);
        },
      );
    } catch (e) {
      return Left("Lỗi ở đây: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<Post>>> getPosts(params) async {
    final result = await _fetchPosts(
      () => postAPI.getPosts(params: params),
    );
    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        return Right(r);
      },
    );
  }

  @override
  Future<Either<String, List<Post>>> getPostById(String id, params) {
    return _fetchPosts(
      () => postAPI.getPostById(id, params: params),
    );
  }

  @override
  Future<Either<String, List<Post>>> getPostsByCategory(
      String categoryId, params) {
    return _fetchPosts(
      () => postAPI.getPostsByCategory(categoryId, params: params),
    ); // Gọi API với categoryId
  }

  @override
  Future<Either<String, List<Post>>> getPostsLiked(params) {
    return _fetchPosts(
      () => postAPI.getPosts(params: params),
    ); // Gọi API với categoryId
  }

  @override
  Future<Either<String, String>> likePost(int postId) async {
    try {
      final result = await postAPI.likePost(postId);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left("Lỗi: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, String>> createPost(
    String title,
    String subTitle,
    String content,
    String image,
    int categoryId,
  ) async {
    try {
      final result = await postAPI.createPost({
        "title": title,
        "subtitle": subTitle,
        "content": content,
        "featured_image": image,
        "status": "published",
        "category": categoryId,
      });
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left("Lỗi: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, String>> updatePost(
    int id,
    String title,
    String subTitle,
    String content,
    String image,
    int categoryId,
  ) async {
    try {
      final result = await postAPI.updatePost(
        id,
        {
          "title": title,
          "subtitle": subTitle,
          "content": content,
          "featured_image": image,
          "status": "published",
          "category": categoryId,
        },
      );
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left("Lỗi: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, String>> uploadImage(File image) async {
    try {
      final result = await postAPI.uploadImage(image);
      log("result upload image api: $result");
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left("Error: ${e.toString()}");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postAPI.deletePost(postId, {});
  }
}
