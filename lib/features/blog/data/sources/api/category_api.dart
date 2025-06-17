import 'dart:developer';

import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/blog/data/models/category_model.dart';

class CategoryAPI {
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await ApiHelper.get(ApiEndpoints.categories["getAll"]!);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        log("Data: $data");
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception("Error get categories: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection error: ${e.toString()}");
    }
  }

  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await ApiHelper.get(
        ApiEndpoints.getCategoryById(id.toString()),
      );
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data["data"]);
      } else {
        throw Exception("Error get category by id: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection error: ${e.toString()}");
    }
  }
}
