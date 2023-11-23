import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:shop_rtx/models/product.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'fixable');
    var db = await openDatabase(path, version: 8,
        onCreate: onCreate, onUpgrade: onUpgrade);
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'price REAL,'
            'image TEXT,'
            'description TEXT,'
            'category TEXT,'
            'quantity INTEGER)'
    );
  }

  onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > 1) {
      await db.execute(
          'CREATE TABLE cart('
              'id INTEGER PRIMARY KEY,'
              'name TEXT,'
              'price REAL,'
              'image TEXT,'
              'description TEXT,'
              'category TEXT,'
              'quantity INTEGER)'
      );
    }
  }

  Future<Product> insert(Product product) async {
    var dbClient = await database;
    await dbClient.insert('fixable', product.toJson());
    return product;
  }

  Future<List<Product>> getFavoriteList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
      await dbClient.query('fixable');
    return queryResult.map((result) => Product.fromJson(result)).toList();
  }

  Future<int> deleteFavoriteItem(int id) async {
    var dbClient = await database;
    return await dbClient.delete('fixable', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('cart');
    return queryResult.map((result) => Product.fromJson(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<Product> insertCart(Product product) async {
    var dbClient = await database;
    await dbClient.insert('cart', product.toJson());
    return product;
  }
}
