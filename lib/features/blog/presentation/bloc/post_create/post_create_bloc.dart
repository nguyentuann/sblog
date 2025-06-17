import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/usecases/post_create_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/post_update_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'post_create_event.dart';
part 'post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  PostCreateBloc()
      : super(PostCreateInitial()) {
    on<CreatePost>(_onCreatePost);
    on<EditPost>(_onEditPost);
     on<UploadImage>(_onUploadImage);
  }

  final  postCreateUsecase = sl<PostCreateUsecase>();
  final  postUpdateUsecase = sl<PostUpdateUsecase>();

  void _onCreatePost(CreatePost event, Emitter<PostCreateState> emit) async {
    emit(PostCreateInProcess());
    final result = await postCreateUsecase.call(
      title: event.title,
      subTitle: event.subTitle,
      content: event.content,
      image: event.featuredImage,
      categoryId: event.categoryId,
    );
    result.fold(
      (l) => emit(PostCreateFailure(l.toString())),
      (r) => emit(PostCreateSuccess(r.toString())),
    );
  }

  void _onEditPost(EditPost event, Emitter<PostCreateState> emit) async {
    emit(PostCreateInProcess());
    final result = await postUpdateUsecase.call(
      event.id,
      title: event.title,
      subTitle: event.subTitle,
      content: event.content,
      image: event.featuredImage,
      categoryId: event.categoryId,
    );
    result.fold(
      (l) => emit(PostCreateFailure(l.toString())),
      (r) => emit(PostCreateSuccess(r.toString())),
    );
  }

  void _onUploadImage(UploadImage event, Emitter<PostCreateState> emit) async {
    emit(UploadImageInProcess());
    final result = await postCreateUsecase.uploadImage(image: event.image);
    result.fold(
      (l) => emit(UploadImageFailure(l.toString())),
      (r) => emit(UploadImageSuccess(r)),
    );
  }
}
