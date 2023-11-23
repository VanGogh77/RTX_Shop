import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/db_helper.dart';
import 'package:shop_rtx/models/product.dart';


class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;
  final _dbHelper = DBHelper();

  void toggleFavorite(Product product) {
    if (_favorites.any((element) => element.id == product.id)) {
      _favorites.removeWhere((element) => element.id == product.id);
      _dbHelper.deleteFavoriteItem(product.id);
    } else {
      _favorites.add(product);
      _dbHelper.insert(Product(
        id: product.id,
        name: product.name,
        category: product.category,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        image: product.image,
      ));
    }
    notifyListeners();
  }

  bool isExist(Product product) {
      final isExist = _favorites.any((element) => element.id == product.id);
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

  Future<void> init() async {
    _favorites = await _dbHelper.getFavoriteList();
    notifyListeners();
  }

  void removeItem(int id) async {
    await _dbHelper.deleteFavoriteItem(id);
    _favorites.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}