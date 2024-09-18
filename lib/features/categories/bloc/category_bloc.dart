import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/category_model.dart';

class CategoriesBloc extends Cubit<List<Category>> {
  CategoriesBloc() : super([]);

  final String _cacheKey = 'categories_cache';

  Future<void> fetchCategories() async {
    try {
      final cachedCategories = await _loadFromCache();
      if (cachedCategories != null) {
        emit(cachedCategories);
      } else {
        final response =
            await Dio().get('https://fakestoreapi.com/products/categories');
        final categories = List<String>.from(response.data)
            .map((e) => Category(name: e))
            .toList();

        emit(categories);
        await _saveToCache(categories);
      }
    } catch (e) {
      emit([]);
    }
  }

  Future<void> _saveToCache(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesList =
        categories.map((category) => category.toJson()).toList();
    prefs.setString(_cacheKey, jsonEncode(categoriesList));
  }

  Future<List<Category>?> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(_cacheKey);

    if (cacheData != null) {
      final List<dynamic> categoryListJson = jsonDecode(cacheData);
      return categoryListJson.map((json) => Category.fromJson(json)).toList();
    }
    return null;
  }
}
