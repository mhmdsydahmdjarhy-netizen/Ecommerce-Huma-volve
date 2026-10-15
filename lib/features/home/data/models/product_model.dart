import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] ?? '',
      images: _cleanImages(json['images']),
    );
  }

  static List<String> _cleanImages(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => e.toString().replaceAll(RegExp(r'[\[\]"]'), '').trim())
        .where((e) => e.startsWith('http'))
        .toList();
  }
}