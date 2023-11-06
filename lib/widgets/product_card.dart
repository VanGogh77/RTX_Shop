import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/providers/favorite_provider.dart';
import 'package:shop_rtx/models/my_product.dart';


class ProductCard extends StatefulWidget {

  final Products product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}


class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => favoriteProvider.toggleFavorite(widget.product),
                child: Icon(
                  favoriteProvider.isExist(widget.product)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 130,
            width: 130,
            child: Image.asset(
              widget.product.image,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),
          Text(
            widget.product.category,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.lightGreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$' '${widget.product.price}',
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
    );
  }
}