import 'package:app/database/firebase/model.dart';
import 'package:sqflite/sqflite.dart';

// < Local Database>
class DBHelper {
  static Database? db;
  static Future<void> createDB() async {
    if (db != null) return;

    try {
      String path = '${await getDatabasesPath()}/specialists.db';
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE specialists (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name  TEXT,
              category  TEXT,
              specialization TEXT,
              availableDays TEXT,
              availableTimes TEXT
            )
          ''');
        },
      );
    } catch (e) {
      print("Database creation error: $e");
    }
  }

  static Future<void> insertToDB(Specialist specialist) async {
    try {
      await db?.insert("specialists", {
        "name": specialist.name,
        "category": specialist.category,
        "specialization": specialist.specialization,
        "availableDays": specialist.availableDays,
        "availableTimes": specialist.availableTimes
      });
    }
    catch (e) {
      print("insert error: $e");
    }
  }

  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      return await db?.query("specialists");
    } catch (e) {
      print("Fetch error: $e");
      return null;
    }
  }

  static Future<void> deleteDB(int id) async {
    await db?.delete("specialists",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<bool> isAlreadyFavourited(String name, String specialization) async {
    final result = await db?.query(
      'specialists',
      where: 'name = ? AND specialization = ?',
      whereArgs: [name, specialization],
    );
    return result != null && result.isNotEmpty;
  }
}