import 'package:flutter/material.dart';
import 'package:sblog/common/presentation/widget/common_avatar.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/service_locator.dart';

class ReplyItem extends StatefulWidget {
  final Comment reply;
  final String authorId;

  const ReplyItem({
    super.key,
    required this.reply,
    required this.authorId,
  });

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  late bool isLiked;
  late int likesCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.reply.isLiked;
    likesCount = widget.reply.likesCount;
  }

  Future<int?> ownerId() async {
    final userId = sl<LocalData>().getUserId();
    return userId ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    final reply = widget.reply;
    return ListTile(
      leading:
          CommonAvatar(url: widget.reply.user.avatar!, size: 30, onTap: () {}),
      title: Text(
        reply.user.id == int.parse(widget.authorId)
            ? '${reply.user.firstname} @Tác giả'
            : reply.user.firstname,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Text(
        widget.reply.content,
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              context.read<CommentBloc>().add(
                    LikeComment(commentId: widget.reply.id),
                  );
              setState(() {
                isLiked = !isLiked;
                likesCount = isLiked ? likesCount + 1 : likesCount - 1;
              });
            },
          ),
          Text('$likesCount', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
