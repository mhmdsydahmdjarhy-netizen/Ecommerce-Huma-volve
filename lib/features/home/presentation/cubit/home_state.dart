import '../../../../core/dummy_data.dart';
import '../../domain/entities/category_entity.dart';

enum HomeStatus { loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<CategoryEntity> categories;
  final List<Product> products;
  final int selectedIndex; // 0 = All
  final String? errorMessage;
  final bool isLoadingMore; // بيجيب الصفحة اللي بعدها دلوقتي
  final bool hasReachedEnd; // مفيش منتجات تانية

  const HomeState({
    this.status = HomeStatus.loading,
    this.categories = const [],
    this.products = const [],
    this.selectedIndex = 0,
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryEntity>? categories,
    List<Product>? products,
    int? selectedIndex,
    String? errorMessage,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}