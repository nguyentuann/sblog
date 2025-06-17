import 'package:flutter/material.dart';
import 'package:sblog/common/presentation/widget/common_avatar.dart';
import 'package:sblog/core/util/datetime_convert.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/usecases/category_get_usecase.dart';
import 'package:sblog/features/blog/presentation/widget/post_widget/post_detail.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';
import 'package:sblog/features/profile/presentation/widget/user_profile.dart';
import 'package:sblog/service_locator.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final bool? isEditable;

  const PostWidget({super.key, required this.post, this.isEditable});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late Future<User?> _userFuture;
  late Future<Category?> _categoryFuture;
  int _ownerId = -1;

  @override
  void initState() {
    super.initState();
    getOwnerId();
    final profileUsecase = sl<ProfileUsecase>();
    final categoryUsecase = sl<CategoryGetUsecase>();
    
    _userFuture = profileUsecase
        .getProfile(widget.post.authorId)
        .then((r) => r.fold((l) => null, (r) => r));
    _categoryFuture = categoryUsecase
        .call(widget.post.categoryId)
        .then((r) => r.fold((l) => null, (r) => r));
  }

  Future<void> getOwnerId() async {
    _ownerId = await ownerId() ?? -1;
  }

  Future<int?> ownerId() async {
    final userId = sl<LocalData>().getUserId();
    return userId ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Color.fromARGB(255, 211, 211, 211),
              width: 0.5,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                FutureBuilder<User?>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                          radius: 18, backgroundColor: Colors.grey);
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return CommonAvatar(
                        url: snapshot.data!.avatar ?? '',
                        size: 36,
                        onTap: snapshot.data!.id == _ownerId
                            ? () {}
                            : () {
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
                                      heightFactor: 0.6,
                                      child: UserProfile(
                                        user: snapshot.data!,
                                      ),
                                    );
                                  },
                                );
                              },
                      );
                    } else {
                      return const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white));
                    }
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<User?>(
                            future: _userFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading...',
                                    style:
                                        Theme.of(context).textTheme.titleSmall);
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return Text(
                                    '${snapshot.data!.firstname} ${snapshot.data!.lastname}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall);
                              } else {
                                return Text('User Unknown',
                                    style:
                                        Theme.of(context).textTheme.titleSmall);
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(widget.post.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FutureBuilder<Category?>(
                          future: _categoryFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('...');
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return Text(snapshot.data!.name,
                                  style: Theme.of(context).textTheme.bodySmall);
                            } else {
                              return const Text('Unknown');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetail(
                      postId: widget.post.id,
                      isEditable: widget.isEditable ?? false,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    child: Image.network(
                      widget.post.featuredImage,
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
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.post.subTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
