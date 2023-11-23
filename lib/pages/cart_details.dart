import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/providers/cart_provider.dart';


class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}


class _CartDetailsState extends State<CartDetails> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    final finalList = provider.cart;

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _buildPRoductQuantity(IconData icon, int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            icon == Icons.add
                ?provider.incrementQuantity(index)
                :provider.decrementQuantity(index);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade600,
          ),
          child: Icon(
            icon,
            size: 20,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            provider.removeItem(finalList[index].id);
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
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '\$${finalList[index].price}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage(finalList[index].image),
                        backgroundColor: Colors.green,
                      ),
                      trailing: Column(
                        children: [
                          _buildPRoductQuantity(Icons.add, index),
                          Text(
                            finalList[index].quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildPRoductQuantity(Icons.remove, index),
                        ],
                      ),
                      tileColor: Colors.grey.shade900,
                    ),
                  ),
                );
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${provider.getTotalPrice()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).clearCart();
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text(
                          'Purchase successful',
                        ),
                      )
                    );
                  },
                  icon: const Icon(Icons.sell_outlined),
                  label: const Text('Purchase'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}