import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/common/presentation/widget/common_avatar.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/presentation/bloc/user_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});
  final User user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late bool isFollowing;
  late int follower;
  @override
  void initState() {
    isFollowing = widget.user.isFollowing;
    follower = widget.user.follower;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonAvatar(url: widget.user.avatar ?? '', size: 200),
                const SizedBox(height: 20),
                Text(
                  "${widget.user.firstname} ${widget.user.lastname}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Followers: $follower",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Following: ${widget.user.following}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserFollowed) {
                      setState(() {
                        isFollowing = !isFollowing;
                        isFollowing ? follower++ : follower--;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: CommonButton(
                        title: isFollowing ? "Unfollow" : "Follow",
                        onPressed: () {
                          context.read<UserBloc>().add(
                                UserFollow(widget.user.id, isFollowing),
                              );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
