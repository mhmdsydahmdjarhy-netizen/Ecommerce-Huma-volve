import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    required int offset,
    required int limit,
  });
  Future<ProductEntity> getProductById(int id);
}