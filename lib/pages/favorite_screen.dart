import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/models/product.dart';
import 'package:shop_rtx/pages/details_screen.dart';
import 'package:shop_rtx/providers/cart_provider.dart';
import 'package:shop_rtx/providers/favorite_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> items = [];
  @override
  Widget build(BuildContext context, ) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final cartProvider = context.watch<CartProvider>();
    final finalList = favoriteProvider.favorites;
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Row(
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                final product = finalList[index];
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
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            favoriteProvider.removeItem(finalList[index].id);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        finalList[index].name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        )
                      ),
                      subtitle: Text(
                        finalList[index].description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.lightGreen,
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        backgroundImage: AssetImage(finalList[index].image),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        color: Colors.red.shade600,
                        onPressed: () {
                          cartProvider.addProduct(product);
                        },
                      ),
                      tileColor: Colors.grey.shade900,
                    ),
                  ),
                ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

