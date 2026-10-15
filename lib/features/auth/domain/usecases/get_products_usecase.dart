import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({int? categoryId}) {
    return _repository.getProducts(categoryId: categoryId);
  }
}