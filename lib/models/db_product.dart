import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:shop_rtx/models/product.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'favorite');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'category TEXT,'
            'description TEXT,'
            'quantity INTEGER,'
            'price REAL,'
            'image TEXT)');
  }

  Future<Product> insert(Product product) async {
    var dbClient = await database;
    await dbClient!.insert('favorite', product.toJson());
    return product;
  }

  Future<List<Product>> getFavoriteList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('favorite');
    return queryResult.map((result) => Product.fromJson(result)).toList();
  }

  Future<int> deleteFavoriteItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('favorite', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getFavoriteId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
    await dbClient!.query('favorite', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Product.fromJson(e)).toList();
  }
}