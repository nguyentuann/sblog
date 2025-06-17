class Post {
  const Post({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.content, // Delta object
    required this.featuredImage,
    required this.createdAt,
    required this.updatedAt,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.authorId,
    required this.categoryId,
    required this.watchCount,
  });

  final int id;
  final String title;
  final String subTitle;
  final List<Map<String, dynamic>> content; // Lưu Delta đã decode
  final String featuredImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final int authorId;
  final int categoryId;
  final int watchCount;
}
