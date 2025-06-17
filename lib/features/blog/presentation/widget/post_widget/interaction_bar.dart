import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/post/post_bloc.dart';
import 'package:sblog/features/blog/presentation/widget/comment_widget/comment_list.dart';

class InteractionBar extends StatefulWidget {
  final int postId;
  final int likeCount;
  final int commentCount;
  final int watchCount;
  final bool isLiked;
  final String authorId;

  const InteractionBar({
    super.key,
    required this.postId,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.watchCount,
    required this.authorId,
  });

  @override
  State<InteractionBar> createState() => _InteractionBarState();
}

class _InteractionBarState extends State<InteractionBar> {
  late int currentLikeCount;
  late bool currentIsLiked;

  @override
  void initState() {
    super.initState();
    currentLikeCount = widget.likeCount;
    currentIsLiked = widget.isLiked;
  }

  void likePost(BuildContext context) {
    setState(() {
      currentIsLiked = !currentIsLiked;
      currentLikeCount =
          currentIsLiked ? currentLikeCount + 1 : currentLikeCount - 1;
    });
    context.read<PostBloc>().add(LikePost(postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostLikeFailure) {
          setState(() {
            currentIsLiked = !currentIsLiked;
            currentLikeCount =
                currentIsLiked ? currentLikeCount + 1 : currentLikeCount - 1;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Like failed! Please try again.')),
          );
        } else if (state is PostLikeSuccess) {
          setState(() {});
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {
              likePost(context);
            },
            label: Text(' $currentLikeCount'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            icon: Icon(
              currentIsLiked ? Icons.favorite : Icons.favorite_border,
              color: currentIsLiked ? Colors.red : Colors.grey,
            ),
          ),

          // Comment
          TextButton.icon(
            icon: const Icon(Icons.comment),
            label: Text(' ${widget.commentCount}'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.8,
                    child: BlocProvider(
                      create: (context) => CommentBloc(),
                      child: CommentList(
                        postId: widget.postId.toString(),
                        authorId: widget.authorId,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Watch
          TextButton.icon(
            icon: const Icon(Icons.remove_red_eye),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            label: Text(' ${widget.watchCount}'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
