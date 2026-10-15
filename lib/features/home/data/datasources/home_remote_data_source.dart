import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories() async {
    final data = await _get(ApiConstants.categories);
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int offset,
    required int limit,
  }) async {
    final url = categoryId == null
        ? ApiConstants.products(offset: offset, limit: limit)
        : ApiConstants.productsByCategory(
            categoryId,
            offset: offset,
            limit: limit,
          );
    final data = await _get(url);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<dynamic>> _get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      throw Exception('Failed to load data (${response.statusCode})');
    } on http.ClientException {
      throw Exception('Network error, check your internet connection');
    }
  }
}
