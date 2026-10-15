import '../../../../core/dummy_data.dart';
import '../../domain/entities/category_entity.dart';

enum HomeStatus { loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<CategoryEntity> categories;
  final List<Product> products;
  final int selectedIndex; // 0 = All
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.categories = const [],
    this.products = const [],
    this.selectedIndex = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryEntity>? categories,
    List<Product>? products,
    int? selectedIndex,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage,
    );
  }
}