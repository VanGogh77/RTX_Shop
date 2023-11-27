import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/db_helper.dart';
import 'package:shop_rtx/models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> items = [];
  List<Product> get cart => items;
  final _dbHelper = DBHelper();

  void addProduct(Product product) {
    if (items.any((element) => element.id == product.id)) {
      for (Product element in items) {
        element.quantity++;
      }
      //items.add(product);
      _dbHelper.updateQuantity(product);
    } else {
      items.add(product);
      _dbHelper.insertCart(Product(
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

  Future<void> init() async {
    items = await _dbHelper.getCartList();
    notifyListeners();
  }

  void removeItem(int id) async {
    await _dbHelper.deleteCartItem(id);
    items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  bool isExist(Product product) {
    final isExist = items.any((element) => element.id == product.id);
    return isExist;
  }

  void incrementQuantity(int index) {
    items[index].quantity ++;
  }
  void decrementQuantity(int index) {
    if (index >= 0 && index < items.length) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
        notifyListeners();
      } else {
        items.removeAt(index);
        _dbHelper.deleteCartItem(index);
      }
    }
  }

  getTotalPrice() {
    double total = 0.0;
    for (Product element in items) {
      total += element.price * element.quantity;
    }
    return total;
  }

  static CartProvider of(
      BuildContext context, {
        bool listen = true,
      }) {
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}