part of 'post_create_bloc.dart';

abstract class PostCreateEvent {}
// Tạo bài viết
class CreatePost extends PostCreateEvent {
  final String title;
  final String subTitle;
  final String content;
  final int categoryId;
  final String featuredImage;

  CreatePost({
    required this.title,
    required this.subTitle,
    required this.content,
    required this.categoryId,
    required this.featuredImage,
  });
}

// Sửa bài viết
class EditPost extends PostCreateEvent {
  final int id;
  final String title;
  final String subTitle;
  final String content;
  final int categoryId;
  final String featuredImage;

  EditPost({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.content,
    required this.categoryId,
    required this.featuredImage,
  });
}


// Upload ảnh
class UploadImage extends PostCreateEvent {
  final File image;
  UploadImage({required this.image});
}

