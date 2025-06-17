import 'dart:developer';

import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/auth/data/models/user_model.dart';

class AuthAPI {
  Future<UserModel> login(String email, String password) async {
    try {
      log("chạy hàm login");
      final response = await ApiHelper.post(ApiEndpoints.auth['login']!, {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        return UserModel.fromJson(
          response.data["data"],
        ); // Chuyển đổi dữ liệu thành UserModel
      } else {
        log("Login failed with status code: ${response.statusCode}");
        throw Exception("Login failed");
      }
    } catch (e) {
      log("Error during login: ${e.toString()}");
      throw Exception("Connection error: ${e.toString()}");
    }
  }

  Future<UserModel> register(
    String firstname,
    String lastname,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiHelper.post(ApiEndpoints.auth['register']!, {
        "first_name": firstname,
        "last_name": lastname,
        "password": password,
        "email": email,
        "is_staff": true,
      });

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Connection error: ${e.toString()}");
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      final response = await ApiHelper.post(ApiEndpoints.auth['logout']!, {
        "refresh_token": refreshToken,
      });

      if (response.statusCode == 200) {
        log("Logout successful");
      } else {
        throw Exception("Logout failed");
      }
    } catch (e) {
      throw Exception("Connection error: ${e.toString()}");
    }
  }

  Future<Map<String, String>> refreshToken(String refreshToken) async {
    try {
      final response = await ApiHelper.post(
        ApiEndpoints.auth['authenticate']!,
        {
          "refresh_token": refreshToken,
        },
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return {
          "accessToken": response.data["data"]["access_token"],
          "refreshToken": response.data["data"]["refresh_token"],
        };
      } else {
        throw Exception("Authentication failed");
      }
    } catch (e) {
      throw Exception("Connection error: ${e.toString()}");
    }
  }
}
