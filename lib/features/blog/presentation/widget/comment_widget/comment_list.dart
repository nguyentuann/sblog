import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/common/presentation/widget/common_textfield.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:sblog/features/blog/presentation/widget/comment_widget/comment_widget.dart';

class CommentList extends StatefulWidget {
  const CommentList({
    super.key,
    required this.postId,
    required this.authorId,
  });

  final String postId;
  final String authorId;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? replyToCommentId;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchComments();
    });
  }

  void _fetchComments() {
    context.read<CommentBloc>().add(GetComments(postId: widget.postId));
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (replyToCommentId == null) {
      if (text.isNotEmpty) {
        context.read<CommentBloc>().add(
              AddComment(
                postId: widget.postId,
                content: text,
              ),
            );
      }
    } else {
      log("goi reply");
      String message = text.split(' ').skip(1).join(' ');
      if (message.isNotEmpty) {
        context.read<CommentBloc>().add(
              ReplyComment(
                content: message,
                parentCommentId: replyToCommentId!,
                postId: widget.postId,
              ),
            );
      }
    }
    _commentController.clear(); // Xóa nội dung ô nhập sau khi gửi
    _focusNode.unfocus(); // Ẩn bàn phím sau khi gửi bình luậm
  }

  void _onReply(int commentId, String firstname) {
    log('goi ham reply $commentId');
    setState(() {
      replyToCommentId = commentId; // Lưu lại ID comment được reply
    });
    _commentController.text = '@$firstname '; // Xóa nội dung ô nhập
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            replyToCommentId = null;
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is CommentFailure) {
                        return Center(
                          child: Column(
                            children: [
                              const Text(
                                "Cannot load comments",
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () => _fetchComments(),
                                icon: const Icon(Icons.replay_outlined),
                                label: Text(
                                  'Reload',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      if (state is CommentLoaded) {
                        comments = state.comments;
                        if (comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments yet.',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CommentWidget(
                                comment: comments[index],
                                onReply: _onReply,
                                authorId: widget.authorId,
                              ),
                            );
                          },
                        );
                      }
                      if (state is CommentSuccess) {
                        context.read<CommentBloc>().add(
                              GetComments(postId: widget.postId),
                            );
                      }
                      return const Center();
                    },
                  ),
                ),
                // Ô nhập bình luận
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Đẩy ô nhập lên khi bàn phím xuất hiện
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: _commentController,
                          focusNode: _focusNode,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
