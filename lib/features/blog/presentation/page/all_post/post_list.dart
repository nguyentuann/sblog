import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/post/post_bloc.dart';
import 'package:sblog/features/blog/presentation/widget/post_widget/post_widget.dart';

class PostList extends StatefulWidget {
  final String? categoryId;
  final int? authorId;
  final bool? isLike;
  final bool? isEditable; // Cho phép sửa/xóa bài viết

  const PostList({
    super.key,
    this.categoryId,
    this.authorId,
    this.isLike,
    this.isEditable, // Mặc định không chỉnh sửa
  });

  @override
  State<PostList> createState() {
    return _PostListState();
  }
}

class _PostListState extends State<PostList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = PostBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPosts(); // Luôn fetch khi vào PostList
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent -
                  MediaQuery.of(context).size.height / 3 &&
          !_isFetching &&
          _hasMore) {
        _fetchMorePosts();
      }
    });
  }

  @override
  void didUpdateWidget(covariant PostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoryId != oldWidget.categoryId ||
        widget.isLike != oldWidget.isLike) {
      _fetchPosts();
    }
  }

  void _fetchPosts() {
    _currentPage = 1;
    _hasMore = true;
    _dispatchFetch();
  }

  void _fetchMorePosts() {
    _currentPage += 1;
    _dispatchFetch();
  }

  void _dispatchFetch() {
    _isFetching = true;

    if (widget.categoryId != null) {
      log('Category ID: ${widget.categoryId}');
      _postBloc.add(
        PostGetStarted(
          page: _currentPage,
          categoryId: widget.categoryId,
        ),
      );
    } else if (widget.isLike == true) {
      log("get cac bai da like");
      _postBloc.add(
        PostGetStarted(
          page: _currentPage,
          liked: true,
        ),
      );
    } else if (widget.authorId != null) {
      _postBloc.add(
        PostGetStarted(
          page: _currentPage,
          authorId: widget.authorId,
        ),
      );
    } else {
      log("gọi categoryId null");
      _postBloc.add(
        PostGetStarted(page: _currentPage),
      );
    }
  }

  @override
  void dispose() {
    _postBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _postBloc,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostGetInProcess) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostGetFailure) {
            _isFetching = false;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Lỗi tải bài viết! Vui lòng thử lại.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchPosts,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (state is PostGetSuccess) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t hanve any post yet!'),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _fetchPosts,
                      child: Text('Reload'),
                    ),
                  ],
                ),
              );
            }
            _hasMore = !state.hasReachedEnd;
            _isFetching = false;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchPosts();
              },
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                primary: false,
                itemCount: posts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    return PostWidget(
                        post: post, isEditable: widget.isEditable);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            );
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
