import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> items = [];
  List<Product> get cart => items;

  void toggleProduct(Product product) {
    if (items.contains(product)) {
      for (Product element in items) {
        element.quantity++;
      }
    } else {
      items.add(product);
    }
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  bool isExist(Product product) {
    final isExist = items.contains(product);
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