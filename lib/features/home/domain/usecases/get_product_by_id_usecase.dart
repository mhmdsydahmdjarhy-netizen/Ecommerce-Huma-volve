import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductByIdUseCase {
  final HomeRepository _repository;

  GetProductByIdUseCase(this._repository);

  Future<ProductEntity> call(int id) => _repository.getProductById(id);
}