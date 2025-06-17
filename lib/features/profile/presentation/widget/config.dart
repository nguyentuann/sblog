import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/presentation/bloc/auth_bloc.dart';

class Config extends StatelessWidget {
  const Config({
    super.key,
  });

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.blueGrey),
            title: Text('Change Theme Mode',
                style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Change Information',
                style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.push('/edit_profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.password),
            title: Text('Change Password',
                style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.push('/change_password');
            },
          ),
          const Divider(),
          BlocListener<AuthBloc, BaseState<User?>>(
            listener: (context, state) {
              if (state is LoadingState) {
                const CircularProgressIndicator();
              } else if (state is SuccessState<User?>) {
                context.go('/auth');
              } else if (state is FailureState<User?>) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title:
                  Text('Logout', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                _showDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  title: 'Cancel',
                ),
                CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AuthBloc>().add(AuthLogoutStarted());
                  },
                  title: 'OK',
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
