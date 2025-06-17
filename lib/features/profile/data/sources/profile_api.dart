import 'package:dartz/dartz.dart';
import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/auth/data/models/user_model.dart';

class ProfileAPI {
  const ProfileAPI();

  Future<Either<String, String>> changePassword(String newPassword) async {
    try {
      final response = await ApiHelper.put('', {'newPassword': newPassword});
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return const Left("Không thể đổi mật khẩu");
      }
    } catch (e) {
      return const Left("Không thể đổi mật khẩu");
    }
  }

  Future<Either<String, String>> updateProfile(UserModel user) async {
    try {
      final response = await ApiHelper.put(ApiEndpoints.updateUser(user.id), {
        'first_name': user.firstname,
        'last_name': user.lastname,
        'bio': user.bio,
        'avatar': user.avatar,
      });
      if (response.statusCode == 200) {
        return Right("Thành công");
      } else {
        return const Left("Không thể cập nhật profile");
      }
    } catch (e) {
      return const Left("Không thể cập nhật profile");
    }
  }

  Future<Either<String, UserModel>> getProfile(int userId) async {
    try {
      final response = await ApiHelper.get(
        ApiEndpoints.getUserById(userId),
      );
      if (response.statusCode == 200) {
        return Right(UserModel.fromJson(response.data));
      } else {
        return const Left("Không thể lấy profile");
      }
    } catch (e) {
      return const Left("Không thể lấy profile");
    }
  }

  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await ApiHelper.get(ApiEndpoints.getUserById(userId));
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception("Không thể lấy user");
      }
    } catch (e) {
      throw Exception("Không thể lấy user: \\${e.toString()}");
    }
  }

  Future<void> followUser(int userId, bool isFollowing) async {
    try {
      String endpoint = isFollowing
          ? ApiEndpoints.unfollowUser(userId)
          : ApiEndpoints.followUser(userId);
      await ApiHelper.post(endpoint, null);
    } catch (e) {
      throw Exception("Không thể theo dõi user: \\${e.toString()}");
    }
  }
}
