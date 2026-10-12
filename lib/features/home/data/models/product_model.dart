import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
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

  // الـ API أحياناً بيرجع روابط الصور بأقواس أو علامات تنصيص زيادة
  static List<String> _cleanImages(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => e.toString().replaceAll(RegExp(r'[\[\]"]'), '').trim())
        .where((e) => e.startsWith('http'))
        .toList();
  }

  // بيحوّل موديل الـ API للكلاس اللي الـ UI متعود عليه
  Product toProduct() {
    return Product(
      id: id.toString(),
      name: title,
      description: description,
      price: price,
      imageUrl: images.isNotEmpty
          ? images.first
          : 'https://picsum.photos/seed/$id/300/300',
      // الـ API مفيهوش ألوان ولا مقاسات، فبنحط قيم افتراضية
      colors: const [Colors.black, Colors.white, Colors.grey],
      sizes: const ['S', 'M', 'L', 'XL'],
    );
  }
}