import 'package:shoesbrand/models/brand.dart';
import 'package:shoesbrand/models/shoe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'kasut_database1.db');
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store brands
  // and a table to store shoes.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {brands} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE brands(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    // Run the CREATE {shoes} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE shoes(id INTEGER PRIMARY KEY, name TEXT, size1 INTEGER, color INTEGER, brandId INTEGER, FOREIGN KEY (brandId) REFERENCES brands(id) ON DELETE SET NULL)',
    );
  }

  // Define a function that inserts brands into the database
  Future<void> insertBrand(Brand brand) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Insert the Brand into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'brands',
      brand.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertShoe(Shoe shoe) async {
    final db = await _databaseService.database;
    await db.insert(
      'shoes',
      shoe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the brands from the brands table.
  Future<List<Brand>> brands() async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Query the table for all the Brands.
    final List<Map<String, dynamic>> maps = await db.query('brands');
    // Convert the List<Map<String, dynamic> into a List<Brand>.
    return List.generate(maps.length, (index) => Brand.fromMap(maps[index]));
  }

  Future<Brand> brand(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('brands', where: 'id = ?', whereArgs: [id]);
    return Brand.fromMap(maps[0]);
  }

  Future<List<Shoe>> shoes() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('shoes');
    return List.generate(maps.length, (index) => Shoe.fromMap(maps[index]));
  }

  // A method that updates a brand data from the brands table.
  Future<void> updateBrand(Brand brand) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Update the given brand
    await db.update(
      'brands',
      brand.toMap(),
      // Ensure that the Brand has a matching id.
      where: 'id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [brand.id],
    );
  }

  Future<void> updateShoe(Shoe shoe) async {
    final db = await _databaseService.database;
    await db
        .update('shoes', shoe.toMap(), where: 'id = ?', whereArgs: [shoe.id]);
  }

  // A method that deletes a brand data from the breeds table.
  Future<void> deleteBrand(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Remove the Brand from the database.
    await db.delete(
      'brands',
      // Use a `where` clause to delete a specific brand.
      where: 'id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteShoe(int id) async {
    final db = await _databaseService.database;
    await db.delete('shoes', where: 'id = ?', whereArgs: [id]);
  }
}
