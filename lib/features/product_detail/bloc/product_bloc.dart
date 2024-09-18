import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/product_model.dart';

class ProductDetailBloc extends Cubit<Product?> {
  ProductDetailBloc() : super(null);

  String _getCacheKey(String id) => 'product_$id';

  Future<void> fetchProduct(String id) async {
    try {
      final cachedProduct = await _loadFromCache(id);
      if (cachedProduct != null) {
        emit(cachedProduct);
      } else {
        final response =
            await Dio().get('https://fakestoreapi.com/products/$id');
        final product = Product.fromJson(response.data);
        emit(product);
        await _saveToCache(id, product);
      }
    } catch (e) {
      emit(null);
    }
  }

  Future<void> _saveToCache(String id, Product product) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_getCacheKey(id), jsonEncode(product.toJson()));
  }

  Future<Product?> _loadFromCache(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(_getCacheKey(id));

    if (cacheData != null) {
      final productJson = jsonDecode(cacheData);
      return Product.fromJson(productJson);
    }
    return null;
  }
}
