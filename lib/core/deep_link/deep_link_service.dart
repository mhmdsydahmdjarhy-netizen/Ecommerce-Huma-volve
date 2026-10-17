import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../features/details/screens/product_details_screen.dart';
import '../../features/home/presentation/mappers/product_mapper.dart';
import '../di/injection.dart';

// مفتاح بنستخدمه عشان ننتقل بين الشاشات من غير context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DeepLinkService {
  DeepLinkService._();

  static final AppLinks _appLinks = AppLinks();
  static late DateTime _startedAt;
  static String? _lastLink;
  static DateTime _lastAt = DateTime(2000);

  static Future<void> init() async {
    _startedAt = DateTime.now();
    try {
      // التطبيق شغال أو في الخلفية وجاله لينك
      _appLinks.uriLinkStream.listen(_handle);

      // التطبيق كان مقفول وفتح من اللينك
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _handle(initial);
    } catch (_) {
      // الـ deep link مش مدعوم على المنصة دي (زي Chrome)، نتجاهل
    }
  }

  static Future<void> _handle(Uri uri) async {
    // نتجاهل نفس اللينك لو اتكرر في ثواني
    final now = DateTime.now();
    if (_lastLink == uri.toString() &&
        now.difference(_lastAt) < const Duration(seconds: 3)) {
      return;
    }
    _lastLink = uri.toString();
    _lastAt = now;

    // لو التطبيق لسه بيفتح، نستنى الـ splash يخلص (4 ثواني)
    const splashTime = Duration(seconds: 4);
    final sinceStart = now.difference(_startedAt);
    if (sinceStart < splashTime) {
      await Future.delayed(splashTime - sinceStart);
    }

    // الشكل المتوقع: ecommerce://product/5
    if (uri.scheme != 'ecommerce' ||
        uri.host != 'product' ||
        uri.pathSegments.isEmpty) {
      return;
    }
    final id = int.tryParse(uri.pathSegments.first);
    if (id == null) return;

    try {
      final entity = await Injection.getProductByIdUseCase(id);
      final navigator = navigatorKey.currentState;
      if (navigator == null) return;
      navigator.push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: entity.toProduct()),
        ),
      );
    } catch (e) {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
    }
  }
}