import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/my_product.dart';


class CartProvider extends ChangeNotifier {
  final List<Products> _cart = [];
  List<Products> get cart => _cart;

  void toggleProduct(Products product) {
    if (_cart.contains(product)) {
      for (Products element in _cart) {
        element.quantity++;
      }
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  bool isExist(Products product) {
    final isExist = _cart.contains(product);
    return isExist;
  }

  void incrementQuantity(int index) => _cart[index].quantity++;
  void decrementQuantity(int index) {
    if (index >= 0 && index < _cart.length) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
        notifyListeners();
      } else {
        _cart.removeAt(index);
      }
    }
  }

  getTotalPrice() {
    double total = 0.0;
    for (Products element in _cart) {
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