import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/db_product.dart';
import 'package:shop_rtx/models/product.dart';


class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;
  final _dbHelper = DBHelper();

  void toggleFavorite(Product product) {
    insert(Product(
      id: product.id,
      name: product.name,
      category: product.category,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      image: product.image,
    ));
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

  Future<void> init() async {
    _favorites = await getFavoriteList();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = _favorites.indexWhere((product) => product.id == id);
    _favorites.removeAt(index);
    notifyListeners();
  }

  Future<Product> insert(Product product) async {
    var dbClient = await _dbHelper.database;
    await dbClient.insert('fixable', product.toJson());
    return product;
  }

  Future<List<Product>> getFavoriteList() async {
    var dbClient = await _dbHelper.database;
    final List<Map<String, Object?>> queryResult =
    await dbClient.query('fixable');
    return queryResult.map((result) => Product.fromJson(result)).toList();
  }

  Future<int> deleteFavoriteItem(int id) async {
    var dbClient = await _dbHelper.database;
    return await dbClient.delete('fixable', where: 'id = ?', whereArgs: [id]);
  }
}