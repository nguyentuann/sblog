import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/common/presentation/widget/common_appbar.dart';
import 'package:sblog/common/presentation/widget/navitem.dart';
import 'package:sblog/features/blog/presentation/page/all_post/post_list.dart';
import 'package:sblog/features/blog/presentation/page/categories/categories_list.dart';
import 'package:sblog/features/profile/presentation/page/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String namePage = 'Home';

  Widget _buildCenterWidget() {
    switch (_selectedIndex) {
      case 0:
        return const PostList();
      case 1:
        return const CategoryListScreen();
      case 2:
        return const PostList(
          isLike: true,
        );
      case 3:
        return const ProfileScreen();
      default:
        return const Center(
          child: Text(
            '❓ Unknown Page',
            style: TextStyle(fontSize: 24),
          ),
        );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        namePage = 'Home';
      } else if (_selectedIndex == 1) {
        namePage = 'Categories';
      } else if (_selectedIndex == 2) {
        namePage = 'Liked';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 3
          ? null
          : CommonAppBar(
              title: namePage,
              actions: [
                IconButton(
                  onPressed: () {
                    context.push('/search');
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
      body: _buildCenterWidget(),
      bottomNavigationBar: BottomAppBar(
        color: GeneralColors.wColor,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              NavItem(
                icon: Icons.topic,
                label: 'Category',
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              Expanded(
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onPressed: () {
                    context.push('/create');
                  },
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
              NavItem(
                icon: Icons.favorite,
                label: 'Liked',
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              NavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
