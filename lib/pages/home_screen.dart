import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shop_rtx/models/products.dart';
import 'package:shop_rtx/widgets/product_card.dart';

import 'details_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = [];

  Future<List<Product>> readJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    return items.map((item) => Product.fromJson(item)).toList();
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  int isSelected = 0;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProductCategory(index: 0, name: 'AllProducts'),
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

  Widget _buildProductCategory({required int index, required String name}) =>
      GestureDetector(
        onTap: () => setState(() => isSelected = index),
        child: Container(
          width: 100,
          height: 40,
          margin: const EdgeInsets.only(top: 10, right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected == index ? Colors.green.shade900 : Colors.green.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget _buildAllProducts() => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: (100 / 130),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    scrollDirection: Axis.vertical,
    itemCount: items.length,
    itemBuilder: (context, index) {
      //final allProducts = items[index];
      return GestureDetector(
      //  onTap: () => Navigator.push(
      //    context,
      //    MaterialPageRoute(
      //      builder: (context) => DetailsScreen(product: items[index]),
      //    ),
      //  ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 130,
                width: 130,
                child: Image.asset(
                  items[index].image,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                items[index].name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              Text(
                items[index].category,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.lightGreen,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$' '${items[index].price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
