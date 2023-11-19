import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/providers/favorite_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  void initState() {
    super.initState();
    context.read<FavoriteProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final finalList = provider.favorites;
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            provider.removeItem(finalList[index].id);
                            //finalList.removeAt(index);
                            //setState(() {});
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
                        )
                      ),
                      subtitle: Text(
                        finalList[index].description,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        backgroundImage: AssetImage(finalList[index].image),
                      ),
                      trailing: Text(
                        '\$${finalList[index].price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tileColor: Colors.grey.shade700,
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

