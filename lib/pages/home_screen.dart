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

enum SortType { newest, priceUp, priceDown, alphabet, reverse }

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = [];

  Future<List<Product>> readJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    return items.map<Product>((item) => Product.fromJson(item)).toList();
  }

  Future<void> loadProducts() async {
    final jsonProducts = await readJson();
    items.addAll(jsonProducts);
    final sortType = await loadSort();
    sort(sortType);
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadSort();
  }

  Future<void> saveSort(SortType sortType) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort', sortType.name);
  }

  Future<SortType> loadSort() async {
    var prefs = await SharedPreferences.getInstance();
    final savedSort = prefs.getString('sort');
    if (savedSort != null) {
      return getSortByName(savedSort);
    }
    return SortType.alphabet;
  }

  SortType getSortByName(String name) {
    for (var sortType in SortType.values) {
      if (sortType.name == name) {
        return sortType;
      }
    }
    return SortType.alphabet;
  }

  Future<void> sortMaxProductPrice() async {
    setState(() {
      items.sort((a, b) => b.price.compareTo(a.price));
    });
  }

  Future<void> sortMinProductPrice() async {
    setState(() {
      items.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  Future<void> sortProductsAlphabetically() async {
    setState(() {
      items.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  Future<void> sortProductsReverse() async {
    setState(() {
      items.sort((a, b) => b.name.compareTo(a.name));
    });
  }

  Future<void> sortProductsDefault() async {
    setState(() {
      items.sort((a, b) => a.id.compareTo(b.id));
    });
  }

  Future<void> sort(SortType sortType) async {
    saveSort(sortType);
    switch (sortType) {
      case SortType.priceUp:
        return sortMaxProductPrice();
      case SortType.priceDown:
        return sortMinProductPrice();
      case SortType.alphabet:
        return sortProductsAlphabetically();
      case SortType.reverse:
        return sortProductsReverse();
      case SortType.newest:
        return sortProductsDefault();
    }
  }

  SortType? mySort;
  Widget _createDropdownItem(String title, void Function() sorting) {
    return DropdownButtonHideUnderline(
      child: (DropdownButton(
          hint: const Text(
              'newest',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              )
          ),
          dropdownColor: Colors.grey.shade900,
          icon: const Icon(
            Icons.sort,
            color: Colors.green,
            size: 30,
          ),
          onChanged: (SortType? value) {
            setState(() {
              mySort = value;
            });
          },
          value: mySort,
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
              _createDropdownItem('sort', () {}),
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