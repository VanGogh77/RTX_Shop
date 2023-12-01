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
  }

  void sortProductPrice(bool product) {
    setState(() {
      _sortAscending = product;
      items.sort((product1, product2) => product
          ? product1.price.compareTo(product2.price)
          : product2.price.compareTo(product1.price));
    });
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
              InkWell(
                onTap: () => sortProductPrice(!_sortAscending),
                child: Row(
                  children: [
                    const Text(
                      'По цене',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // the up/down arrow that indicates the sort order
                    Icon(
                      _sortAscending
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.green.shade300,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => sortProductsName(!_sortAscending),
                child: Row(
                  children: [
                    const Text(
                      'По названию',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // the up/down arrow that indicates the sort order
                    Icon(
                      _sortAscending
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      color: Colors.green.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
