import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/category/categories_bloc.dart';
import 'package:sblog/features/blog/presentation/widget/category_widget/category_widget.dart';

// ignore: must_be_immutable
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(),
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is! CategoriesLoading &&
              state is! CategoriesLoaded &&
              state is! CategoryError) {
            context.read<CategoriesBloc>().add(GetCategories());
          }
          if (state is CategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryError) {
            return const Center(child: Text("Error loading categories"));
          } else if (state is CategoriesLoaded) {
            final categories = state.categories;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoriesBloc>().add(GetCategories());
              },
              child: Scaffold(
                body: categories.isEmpty
                    ? const Center(child: Text("No categories available"))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryWidget(
                              category: categories[index],
                              bgColor: const Color.fromARGB(255, 141, 200, 227),
                            );
                          },
                        ),
                      ),
              ),
            );
          }
          return Container(); // Return an empty container while loading
        },
      ),
    );
  }
}
