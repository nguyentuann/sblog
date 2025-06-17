import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/presentation/bloc/post/post_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/post_detail/post_detail_bloc.dart';
import 'package:sblog/features/blog/presentation/page/create_post/new_post.dart';
import 'package:sblog/features/blog/presentation/widget/post_widget/interaction_bar.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({
    super.key,
    required this.postId,
    required this.isEditable,
  });

  final int postId;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailBloc>(
      create: (context) =>
          PostDetailBloc()..add(PostGetById(postId: postId.toString())),
      child: _PostDetailBody(
        postId: postId,
        isEditable: isEditable,
      ),
    );
  }
}

class _PostDetailBody extends StatefulWidget {
  final int postId;
  final bool isEditable;
  const _PostDetailBody({
    required this.postId,
    required this.isEditable,
  });
  @override
  State<_PostDetailBody> createState() => _PostDetailBodyState();
}

class _PostDetailBodyState extends State<_PostDetailBody> {
  bool isLiked = false;
  int likeCount = 0;
  QuillController? _controller;
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  void _loadContent(dynamic content) {
    log('Loading content: $content');
    try {
      // Nếu post.content đã là một list Map => không cần jsonDecode nữa
      final doc = Document.fromJson(List<Map<String, dynamic>>.from(content));
      _controller = QuillController(
        readOnly: true,
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      final doc = Document()..insert(0, 'Không thể tải nội dung');
      _controller = QuillController(
        readOnly: true,
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailBloc, PostDetailState>(
      builder: (context, state) {
        if (state is PostGetInProcess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PostGetByIdedSuccess) {
          final post = state.post;
          likeCount = post.likeCount;
          isLiked = post.isLiked;
          if (_controller == null) {
            _loadContent(post.content); // post.content dạng List<Map>
          }
          return Scaffold(
            appBar: _buildAppBar(post),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.subTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      post.featuredImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/bg.jpg',
                          fit: BoxFit.contain,
                          width: double.infinity,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocProvider(
                        create: (context) => PostBloc(),
                        child: InteractionBar(
                          postId: post.id,
                          likeCount: likeCount,
                          commentCount: post.commentCount,
                          isLiked: isLiked,
                          watchCount: post.watchCount,
                          authorId: post.authorId.toString(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        scrollable: false,
                        controller: _controller!,
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        } else if (state is PostGetByIdFailure) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                "Không thể tải bài viết: ${state.message}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text("Đang tải bài viết...")),
          );
        }
      },
    );
  }

  AppBar _buildAppBar(Post post) {
    return AppBar(
      actions: [
        if (widget.isEditable)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostScreen(
                        post: post,
                      ),
                    ),
                  );
                  if (result) {
                    context
                        .read<PostDetailBloc>()
                        .add(PostGetById(postId: widget.postId.toString()));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    context.read<PostDetailBloc>().add(
                          DeletePost(
                            postId: widget.postId.toString(),
                          ),
                        );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
      ],
    );
  }
}
