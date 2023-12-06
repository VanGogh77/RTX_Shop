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

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = [];
  bool _sortAscending = true;
  String? dropdownValue;
  static const sortKey = 'sortKey';

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

  Future<void> sortProductPrice(bool product) async {
    setState(() {
      _sortAscending = product;
      items.sort((product1, product2) => product
          ? product1.price.compareTo(product2.price)
          : product2.price.compareTo(product1.price));
    });
    await _setSort();
  }

  Future _setSort() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(sortKey, jsonEncode(items));
  }

  Future<Product> _getSort() async {
    var prefs = await SharedPreferences.getInstance();
    final context = prefs.getString(sortKey);

    return Product.fromJson(jsonDecode(context!));
  }

  void sortProductsName(bool product) {
    setState(() {
      _sortAscending = product;
      items.sort((product1, product2) => product
          ? product1.name.compareTo(product2.name)
          : product2.name.compareTo(product1.name));
    });
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
              DropdownButton(
                dropdownColor: Colors.grey.shade900,
                value: dropdownValue,
                icon: const Icon(
                  Icons.sort,
                  color: Colors.green,
                  size: 30,
                ),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    onTap: () => sortProductPrice(!_sortAscending),
                    value:'PriceMax',
                    child: const Row(
                      children: [
                        Text(
                          'Дороже',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    onTap: () => sortProductPrice(!_sortAscending),
                    value:'PriceMin',
                    child: const Row(
                      children: [
                        Text(
                          'Дешевле',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    onTap: () => sortProductsName(!_sortAscending),
                    value:'Name2',
                    child: const Row(
                      children: [
                        Text(
                          'Z-a',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    onTap: () => sortProductsName(!_sortAscending),
                    value:'Name',
                    child: const Row(
                      children: [
                        Text(
                          'A-z',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 11),
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
