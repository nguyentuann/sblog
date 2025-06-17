import 'package:sblog/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static const String _accessToken = "access_token";
  static const String _refreshToken = "refresh_token";
  static const String _userId = "user_id";

  final prefs = sl<SharedPreferences>();

  /// Lưu thông tin đăng nhập
  Future<void> saveAuthData(
      String accessToken, String refreshToken, int userId) async {
    await prefs.setString(_accessToken, accessToken);
    await prefs.setString(_refreshToken, refreshToken);
    await prefs.setInt(_userId, userId);
  }

  /// Lấy token đã lưu
  String? getAccessToken() {
    return prefs.getString(_accessToken);
  }

  String? getRefreshToken() {
    return prefs.getString(_refreshToken);
  }

  int? getUserId() {
    return prefs.getInt(_userId);
  }

  /// Xóa thông tin đăng nhập
  Future<void> clearAuthData() async {
    await prefs.remove(_accessToken);
    await prefs.remove(_refreshToken);
    await prefs.remove(_userId);
  }
}
