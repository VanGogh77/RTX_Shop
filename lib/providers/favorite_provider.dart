import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_rtx/models/db_product.dart';
import 'package:shop_rtx/models/product.dart';


class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isExist(Product product) {
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

// Это все таки инициатор для загрузки _favorites )))

  Future<void> getData() async {
    _favorites = await DBHelper().getFavoriteList();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = _favorites.indexWhere((product) => product.id == id);
    _favorites.removeAt(index);
    notifyListeners();
  }
}