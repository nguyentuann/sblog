import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/common/presentation/widget/common_avatar.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sblog/features/profile/presentation/widget/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/profile/presentation/widget/infor_bar.dart';
import 'package:sblog/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userId,
  });
  final int? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final localData = sl<LocalData>();
  int? userId;
  // Thêm async vào initState để chờ SharedPreferences
  @override
  void initState() {
    super.initState();
    _initializeLocalData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalData();
    });
  }

  Future<void> _initializeLocalData() async {
    if (widget.userId == null) {
      userId = localData.getUserId();

      if (userId != null) {
        fetchProfile(userId!);
      }
    } else {
      log("goi widget.userId");
      fetchProfile(widget.userId!);
    }
  }

  void fetchProfile(int userId) {
    context.read<ProfileBloc>().add(ProfileGet(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      endDrawer: widget.userId != null
          ? null
          : const Drawer(
              child: Config(),
            ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CommonAvatar(url: user.avatar ?? '', size: 120),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${user.lastname} ${user.firstname}',
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2, // Giới hạn tối đa 2 dòng
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${user.bio}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            softWrap: true, // Cho phép xuống dòng
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Followers: ${user.follower}'),
                              SizedBox(width: 10),
                              Text('Following: ${user.following}'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (widget.userId != null)
                            CommonButton(
                              title: 'Follow',
                              onPressed: () {},
                            ),
                          if (widget.userId == null)
                            CommonButton(
                              title: 'Create Post',
                              onPressed: () {
                                context.push('/create');
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    InforBar(
                      title: 'Posts',
                      icon: Icons.article,
                      onPressed: () {
                        context.push(
                          '/post_list_user_id',
                          extra: {
                            'userId': widget.userId ?? userId!,
                            'isEditable': userId != null ? true : false,
                          },
                        );
                      },
                    ),
                    const Divider(),
                    InforBar(
                      title: 'Information',
                      icon: Icons.person,
                      onPressed: () async {
                        final result = await context.push(
                          '/edit_profile',
                          extra: {'user': user},
                        );
                        if (result == true) {
                          fetchProfile(widget.userId ?? userId!);
                        }
                      },
                    ),
                    const Divider(),

                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cannot load profile.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () => _initializeLocalData(),
                    icon: const Icon(Icons.replay_outlined),
                    label: const Text('Reload'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
