import 'package:flutter/material.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/presentation/widget/post_widget/post_detail.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.featuredImage),
              radius: 30,
            ),
            title: Text(
              post.title,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post.subTitle,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetail(postId: post.id, isEditable: false),
                ),
              );
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
