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
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  // Если что - менять таблицу
  onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE fixable('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'price REAL,'
            'image TEXT,'
            'description TEXT,'
            'category TEXT,'
            'quantity INTEGER)'
    );
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
}
