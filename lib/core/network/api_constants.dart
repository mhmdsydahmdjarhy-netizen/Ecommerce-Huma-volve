class ApiConstants {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/users/';
  static const String categories = '$baseUrl/categories';

  // الـ API بيطلب avatar عند التسجيل، فبنبعت لينك ثابت
  static const String defaultAvatar = 'https://picsum.photos/800';

  static String products({required int offset, required int limit}) =>
      '$baseUrl/products?offset=$offset&limit=$limit';

  static String productsByCategory(
    int id, {
    required int offset,
    required int limit,
  }) =>
      '$baseUrl/categories/$id/products?offset=$offset&limit=$limit';
}