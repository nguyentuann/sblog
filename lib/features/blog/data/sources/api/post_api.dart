import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/blog/data/models/post_model.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';

class PostAPI {
  // Hàm này sẽ gọi API để lấy danh sách bài viết từ server
  Future<Either<String, List<PostModel>>> _fetchPosts(
    String endpoint,
    params,
  ) async {
    try {
      final response = await ApiHelper.get(endpoint, params: params);
      if (response.statusCode == 200) {
        final data = response.data["data"]["blogs"] ?? response.data["data"];
        try {
          // Kiểm tra nếu data là một List
          if (data is List) {
            List<PostModel> result = [];
            try {
              result = data
                  .map(
                    (json) => PostModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            } catch (e) {
              log("loi khi chuyen doi data: $e");
            }

            return Right(result);
          } else {
            final result = PostModel.fromJson(data);
            return Right([result]);
          }
        } catch (e) {
          return const Left("Lỗi khi chuyển đổi dữ liệu.");
        }
      } else {
        return Left("Lỗi từ server: ${response.statusCode}");
      }
    } catch (e) {
      return Left("Lỗi khi tải bài viết: ${e.toString()}");
    }
  }

  // lấy tất cả bài viết
  Future<Either<String, List<PostModel>>> getPosts({
    Map<String, dynamic>? params,
  }) {
    return _fetchPosts(ApiEndpoints.posts["getAll"]!, params);
  }

  // lấy bài viết theo id
  Future<Either<String, List<PostModel>>> getPostById(
    String id, {
    Map<String, dynamic>? params,
  }) {
    return _fetchPosts(ApiEndpoints.getPostById(id), params);
  }

  // lấy bài viết theo danh mục
  Future<Either<String, List<PostModel>>> getPostsByCategory(
    String categoryId, {
    Map<String, dynamic>? params,
  }) =>
      _fetchPosts(ApiEndpoints.getPostsByCategory(categoryId), params);

  Future<Either<String, List<PostModel>>> getPostsLiked({
    Map<String, dynamic>? params,
  }) =>
      _fetchPosts(ApiEndpoints.posts["getAll"]!, params);

  // thích 1 bài viết
  Future<Either<String, String>> likePost(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    try {
      
      final response = await ApiHelper.post(ApiEndpoints.likePost(id), params);
      log("response like post: ${response.data}");
      if (response.statusCode == 200) {
        return const Right('Thành công');
      }
      return const Left('Thất bại');
    } catch (e) {
      return Left("Lỗi khi like bài viết: ${e.toString()}");
    }
  }

  Future<Either<String, String>> createPost(Map<String, dynamic> data) async {
    try {
      final response =
          await ApiHelper.post(ApiEndpoints.posts["create"]!, data);
      if (response.statusCode == 201) {
        return Right(response.data['message']);
      }
      return const Left('Thất bại');
    } catch (e) {
      return Left("Lỗi khi tạo bài viết: ${e.toString()}");
    }
  }

  Future<Either<String, String>> updatePost(
      int id, Map<String, dynamic> data) async {
    try {
      final response =
          await ApiHelper.put(ApiEndpoints.updatePost(id.toString()), data);
      if (response.statusCode == 200) {
        return Right(response.data['message']);
      }
      return const Left('Thất bại');
    } catch (e) {
      return Left("Lỗi khi update bài viết: ${e.toString()}");
    }
  }

  Future<Either<String, String>> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await ApiHelper.post(ApiEndpoints.uploadImage, formData);
      log("response upload image: ${response.data["data"]["url"]}");

      if (response.statusCode == 201) {
        return Right(response.data["data"]['url']);
      }
      return const Left('Thất bại');
    } catch (e) {
      return Left("Lỗi khi tải ảnh: ${e.toString()}");
    }
  }

  Future<Either<String, String>> deletePost(
      String postId, Map<String, dynamic> data) async {
    try {
      final response =
          await ApiHelper.delete(ApiEndpoints.deletePost(postId.toString()));
      if (response.statusCode == 200) {
        return Right(response.data['message']);
      }
      return const Left('Thất bại');
    } catch (e) {
      return Left("Lỗi khi update bài viết: ${e.toString()}");
    }
  }
}
