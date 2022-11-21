import 'dart:io';

import 'package:myapp/CustomerModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Customer.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customer(
        id INT PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        email TEXT
      )
 ''');
  }

  Future<int> add(CustomerModel customerModel) async {
    Database db = await instance.database;
    return db.insert('customer', customerModel.toMap());
  }

  Future<List<CustomerModel>> get() async {
    Database db = await instance.database;
    var customer = await db.query('customer', orderBy: 'id');
    List<CustomerModel> customerList = customer.isNotEmpty
        ? customer.map((data) => CustomerModel.fromMap(data)).toList()
        : [];
    return customerList;
  }

  Future<int> update(CustomerModel customerModel) async {
    Database db = await instance.database;
    return await db.update(
      'customer',
      customerModel.toMap(),
      where: 'id = ?',
      whereArgs: [customerModel.id],
    );
  }

  Future<int> delete(int? id) async {
    Database db = await instance.database;
    return await db.delete(
      'customer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
