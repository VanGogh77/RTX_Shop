
import 'package:flutter/material.dart';
import 'package:shop_rtx/models/my_product.dart';
import 'package:shop_rtx/pages/details_screen.dart';

import '../widgets/product_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

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
              _buildProductCategory(index: 1, name: 'CPU'),
              _buildProductCategory(index: 2, name: 'VideoCard'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isSelected == 0
                ? _buildAllProducts()
                : isSelected == 1
                  ? _buildCPUs()
                  : _buildCards(),
          ),
        ],
      ),
    );
  }

  _buildProductCategory({required int index, required String name}) =>
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

  _buildAllProducts() => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: (100 / 140),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    scrollDirection: Axis.vertical,
    itemCount: MyProduct.AllProducts.length,
    itemBuilder: (context, index) {
      final allProducts = MyProduct.AllProducts[index];
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(product: allProducts),
          ),
        ),
        child: ProductCard(product: allProducts),
      );
    },
  );

  _buildCPUs() => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: (100 / 140),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    scrollDirection: Axis.vertical,
    itemCount: MyProduct.CPU.length,
    itemBuilder: (context, index) {
      final cpuList = MyProduct.CPU[index];
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(product: cpuList),
          ),
        ),
      );
    },
  );

  _buildCards() => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: (100 / 140),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    scrollDirection: Axis.vertical,
    itemCount: MyProduct.VideoCard.length,
    itemBuilder: (context, index) {
      final cardsList = MyProduct.VideoCard[index];
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(product: cardsList),
          ),
        ),
      );
    },
  );
}
