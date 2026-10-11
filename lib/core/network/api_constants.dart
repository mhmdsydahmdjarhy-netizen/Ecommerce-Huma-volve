class ApiConstants {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/users/';

  // الـ API بيطلب avatar عند التسجيل، فبنبعت لينك ثابت
  static const String defaultAvatar = 'https://picsum.photos/800';
}