import 'package:flutter/material.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';
import 'package:sblog/features/blog/presentation/page/all_post/post_list.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.category,
    this.bgColor = Colors.white,
  });

  final Category category;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(category.name)),
                body: PostList(
                  key: ValueKey('category_${category.id}'),
                  categoryId: category.id.toString(),
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Card(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
