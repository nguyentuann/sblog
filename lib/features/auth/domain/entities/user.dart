// Dữ liệu trong ứng dụng
class User {
  final int id; // ID người dùng, mặc định là 0
  final String firstname;
  final String lastname;
  final String email;
  final int follower; // Số lượng người theo dõi
  final int following; // Số lượng người đang theo dõi
  final String? avatar;
  final String? bio;
  final bool isFollowing; // Kiểm tra xem người dùng có đang theo dõi hay không

  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.follower,
    required this.following,
    this.avatar,
    this.bio,
    required this.isFollowing,
  });
}
