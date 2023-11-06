import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/my_product.dart';


class FavoriteProvider extends ChangeNotifier {
  final List<Products> _favorites = [];
  List<Products> get favorites => _favorites;

  void toggleFavorite(Products product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isExist(Products product) {
      final isExist = _favorites.contains(product);
      return isExist;
    }

  static FavoriteProvider of(
      BuildContext context, {
        bool listen = true,
      }) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}