import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';
import '../../domain/entities/product_entity.dart';

extension ProductEntityMapper on ProductEntity {
  Product toProduct() {
    return Product(
      id: id.toString(),
      name: title,
      description: description,
      price: price,
      imageUrl: images.isNotEmpty
          ? images.first
          : 'https://picsum.photos/seed/$id/300/300',
      colors: const [Colors.black, Colors.white, Colors.grey],
      sizes: const ['S', 'M', 'L', 'XL'],
    );
  }
}
