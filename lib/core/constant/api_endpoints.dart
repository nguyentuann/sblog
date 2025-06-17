class ApiEndpoints {
  static const String baseUrl =
      "https://sblog-api-production.up.railway.app/";

  static const Map<String, String> auth = {
    "login": "/api/auth/login/",
    "logout": "/api/auth/logout/",
    "register": "/api/auth/register/",
    "authenticate": "/api/auth/refresh/",
  };

  static const Map<String, String> categories = {
    "getAll": "/api/categories/",
    "create": "/api/categories/",
  };

  static const Map<String, String> comments = {
    "getAll": "/api/comments/",
    "create": "/api/comments/",
    "reply": "/api/comments/reply/",
  };

  static const Map<String, String> posts = {
    "getAll": "/api/posts",
    "create": "/api/posts/",
  };

  static const Map<String, String> users = {
    "getAll": "/api/users/",
    "create": "/api/users/",
  };

  static const Map<String, String> search = {
    "search": "/api/search/",
  };

  static const String uploadImage = "/api/upload/";

  static String getCategoryById(String id) => "/api/categories/$id/";
  static String updateCategory(String id) => "/api/categories/$id/";
  static String deleteCategory(String id) => "/api/categories/$id/";

  static String getCommentById(String id) => "/api/comments/by-post/$id/";
  static String updateComment(String id) => "/api/comments/$id/";
  static String deleteComment(String id) => "/api/comments/$id/";
  static String likeComment(String id) => "/api/comments/$id/like/";


  static String getPostById(String id) => "/api/posts/$id/";
  static String updatePost(String id) => "/api/posts/$id/";
  static String deletePost(String id) => "/api/posts/$id/";
  static String likePost(int id) => "/api/posts/$id/like/";
  static String getPostsByCategory(String id) => "/api/categories/$id/posts/";

  static String getUserById(int id) => "/api/users/$id/";
  static String updateUser(int id) => "/api/users/$id/";
  static String deleteUser(int id) => "/api/users/$id/";
  static String getFollowers(int id) => "/api/users/$id/followers/";
  static String getFollowing(int id) => "/api/users/$id/following/";
  static String followUser(int id) => "/api/users/$id/follow/";
  static String unfollowUser(int id) => "/api/users/$id/unfollow/";
}
