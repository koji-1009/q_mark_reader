import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableUrlEntry = 'url_entry';
final String columnUrl = 'url';
final String columnDate = 'date';

class UrlEntry {
  String url;
  DateTime dateTime;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUrl: url,
      columnDate: dateTime.toIso8601String()
    };

    return map;
  }

  UrlEntry(String url) {
    this.url = url;
    this.dateTime = DateTime.now();
  }

  UrlEntry.fromMap(Map<String, dynamic> map) {
    url = map[columnUrl];
    dateTime = DateTime.parse(map[columnDate]);
  }
}

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'database.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableUrlEntry (
          $columnUrl text  primary key not null,
          $columnDate text not null)
          ''');
    });
  }
}

class UrlEntryHelper {
  final provider = DBProvider.db;

  Future<int> insert(String url) async {
    final db = await provider.database;

    final entry = UrlEntry(url);
    final newRow = await db.insert(tableUrlEntry, entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return newRow;
  }

  Future<List<UrlEntry>> getUrlEntryList() async {
    final db = await provider.database;

    final maps = await db
        .rawQuery('SELECT * FROM $tableUrlEntry ORDER BY date($columnDate)');
    if (maps.isNotEmpty) {
      return maps
          .map((value) => UrlEntry.fromMap(value))
          .toList(growable: false);
    }

    return [];
  }

  Future<int> delete(String url) async {
    final db = await provider.database;

    return await db
        .delete(tableUrlEntry, where: '$columnUrl = ?', whereArgs: [url]);
  }

  Future close() async {
    final db = await provider.database;

    await db.close();
  }
}
