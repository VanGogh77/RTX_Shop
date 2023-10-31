import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/product.dart';


class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  List<Product> get cart => _cart;

  void toggleProduct(Product product) {
    if (_cart.contains(product)) {
      _cart.remove(product);
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  bool isExist(Product product) {
    final isExist = _cart.contains(product);
    return isExist;
  }

  incrementQuantity(int index) => _cart[index].quantity++;
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
    for (Product element in _cart) {
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
