
import 'package:flutter/material.dart';
import 'package:shop_rtx/pages/cart_details.dart';
import 'package:shop_rtx/pages/favorite_screen.dart';
import 'package:shop_rtx/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_rtx/providers/cart_provider.dart';
import 'package:shop_rtx/providers/favorite_provider.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: MaterialApp(
          title: 'RTX - Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            scaffoldBackgroundColor: Colors.grey.shade900,
          ),
          home: const MyHomePage(),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    context.read<FavoriteProvider>().init();
    context.read<CartProvider>().init();
    super.initState();
  }

  int currentIndex = 0;
  List <Widget>screens = [
    const HomeScreen(),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RTX - Shop'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartDetails(),
                  ),
                ),
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade900,
        backgroundColor: Colors.green.shade800,
        selectedIconTheme: const IconThemeData(size: 35),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: false,
        items: const[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}