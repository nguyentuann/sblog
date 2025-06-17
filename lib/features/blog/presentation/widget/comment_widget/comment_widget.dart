import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/common/presentation/widget/common_avatar.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:sblog/features/blog/presentation/widget/comment_widget/reply_item.dart';
import 'package:sblog/service_locator.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.onReply,
    required this.authorId,
  });

  final Comment comment;
  final Function(int, String) onReply;
  final String authorId;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool showReplies = false;
  late List<Comment> replies;
  bool isLiked = false;
  int likesCount = 0;
  @override
  void initState() {
    super.initState();
    replies = widget.comment.replies;
    isLiked = widget.comment.isLiked;
    likesCount = widget.comment.likesCount;
  }

  void likeComment(BuildContext context, int commentId) {
    context.read<CommentBloc>().add(LikeComment(commentId: commentId));
    setState(() {
      isLiked = !isLiked;
      likesCount = isLiked ? likesCount + 1 : likesCount - 1;
    });
  }

  Future<int?> ownerId() async {
    final userId = sl<LocalData>().getUserId();
    return userId ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    log(comment.user.toString());
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC7C7C7)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonAvatar(
            url: comment.user.avatar ?? '',
            size: 30,
            // onTap: () => context.push('/profile', extra: comment.user.id),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.id == int.parse(widget.authorId)
                      ? '${comment.user.firstname} @Tác giả'
                      : comment.user.firstname,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(comment.content),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => showReplies = !showReplies),
                      child: Text(
                        "Replies (${comment.replies.length})",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.reply, color: Colors.green),
                      onPressed: () =>
                          widget.onReply(comment.id, comment.user.firstname),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => likeComment(context, comment.id),
                        ),
                        Text(
                          likesCount.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                if (showReplies)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      return ReplyItem(
                        reply: replies[index],
                        authorId: widget.authorId,
                        // onLike: () => likeComment(context, replies[index].id),
                      );
                    },
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
