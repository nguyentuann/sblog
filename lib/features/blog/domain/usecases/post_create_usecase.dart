import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostCreateUsecase {

  final repository = sl<PostRepository>();

  Future<Either<String, String>> call({
    required String title,
    required String subTitle,
    required String content,
    required String image,
    required int categoryId,
  }) async {
    return await repository.createPost(title, subTitle, content, image, categoryId);
  }

  Future<Either<String, String>> uploadImage({
    required File image,
  }) async {
    return await repository.uploadImage(image);
  }
}

