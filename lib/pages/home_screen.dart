import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_rtx/models/product.dart';
import 'package:shop_rtx/pages/details_screen.dart';
import 'package:shop_rtx/providers/cart_provider.dart';
import 'package:shop_rtx/providers/favorite_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum SortType { priceUp, priceDown, alphabet, reverse }

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = [];
  bool _sortAscending = true;

  Future<List<Product>> readJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    return items.map<Product>((item) => Product.fromJson(item)).toList();
  }

  Future<void> loadProducts() async {
    final jsonProducts = await readJson();
    setState(() {
      items.addAll(jsonProducts);
    });
  }

  @override
  void initState() {
    loadProducts();
    super.initState();
    _getSort();
  }

  Future _setSort() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('sort', jsonEncode(items));
  }

  Future<String?> _getSort() async {
    var prefs = await SharedPreferences.getInstance();
    final context = prefs.getString('sort');
    if (context == null) return null;
    return context;
  }

  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _createDropdownItem('Sort', () {}),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildAllProducts(),
          ),
        ],
      ),
    );
  }

  Future<void> sortMaxProductPrice(bool product) async {
    setState(() {
      _sortAscending = product;
      items.sort((a, b) => b.price.compareTo(a.price));
    });
  }

  Future<void> sortMinProductPrice(bool product) async {
    setState(() {
      _sortAscending = product;
      items.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  Future<void> sortProductsAlphabetically(bool product) async {
    setState(() {
      _sortAscending = product;
      items.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  Future<void> sortProductsReverse(bool product) async {
    setState(() {
      _sortAscending = product;
      items.sort((a, b) => b.name.compareTo(a.name));
    });
  }

  Future<void> sort(SortType sortType) async {
    _setSort();
    switch (sortType) {
      case SortType.priceUp:
        return sortMaxProductPrice(false);
      case SortType.priceDown:
        return sortMinProductPrice(false);
      case SortType.alphabet:
        return sortProductsAlphabetically(false);
      case SortType.reverse:
        return sortProductsReverse(false);
    }
  }

  SortType? mySort;
  Widget _createDropdownItem(String title, void Function() sorting) {
    return DropdownButtonHideUnderline(
      child: (DropdownButton(
          dropdownColor: Colors.grey.shade900,
          icon: const Icon(
            Icons.sort,
            color: Colors.green,
            size: 30,
          ),
          value: mySort,
          onChanged: (SortType? value) {
            setState(() {
              mySort = value;
            });
          },
          items: SortType.values.map((SortType type) {
            return DropdownMenuItem<SortType>(
              onTap: () => sort(type),
              value: type,
              child: Text(
                type.name,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            );
          }).toList())),
    );
  }

  Widget _buildAllProducts() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final favoriteProvider = context.watch<FavoriteProvider>();
          final cartProvider = context.watch<CartProvider>();
          final product = items[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(product: product),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          favoriteProvider.toggleFavorite(product);
                        },
                        child: Icon(
                          favoriteProvider.isExist(product)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.lightGreen,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$' '${product.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cartProvider.addProduct(product);
                          },
                          child: Icon(
                            cartProvider.isExist(product)
                                ? Icons.add_shopping_cart
                                : Icons.add_shopping_cart,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
