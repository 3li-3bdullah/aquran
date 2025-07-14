import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:hive/hive.dart';

class LocalDB {
  static Box? _prefsBox;
  static Box<SurahDB>? _surahBox;
  static Box<Verse>? _verseBox;

  static bool _isInitialized = false;

  // Initialize Hive and open boxes
  static Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SurahAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VerseAdapter());
    }


    // Open boxes
    _prefsBox = await Hive.openBox('prefs');
    _surahBox = await Hive.openBox<SurahDB>('surahs');
    _verseBox = await Hive.openBox<Verse>('verses');

    // Check if boxes are empty
    if (_surahBox!.isEmpty) {
      _addSampleData();
    }

    _isInitialized = true;
  }

  static void _addSampleData() {
    // Sample Surah 1
    _surahBox?.put(
        1,
        SurahDB()
          ..number = 1
          ..name = 'الفاتحة'
          ..englishName = 'Al-Fatihah');

    // Sample Verses
    _verseBox?.putAll({
      1: Verse(
          surahNumber: 1,
          number: 1,
          text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
      2: Verse(
          surahNumber: 1,
          number: 2,
          text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'),
    });
  }

  // ================ CORE FUNCTIONS (EXACT NAMES YOU WANTED) ================

  static dynamic getValue(String key) => _prefsBox?.get(key);

  static void updateValue(String key, dynamic value) =>
      _prefsBox?.put(key, value);

  static SurahDB? getSurah(int number) => _surahBox?.get(number);

  static List<Verse> getVerses(int surahNumber) =>
      _verseBox!.values.where((v) => v.surahNumber == surahNumber).toList()
        ..sort((a, b) => a.number.compareTo(b.number));

  static void updateSurah(SurahDB surah) => _surahBox?.put(surah.number, surah);

  static void updateVerse(Verse verse) => _verseBox?.put(verse.number, verse);

  static void close() {
    _prefsBox?.close();
    _surahBox?.close();
    _verseBox?.close();
  }
}

// ==================== MODELS ====================
@HiveType(typeId: 0)
class SurahDB {
  @HiveField(0)
  late int number;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String englishName;
  @HiveField(3)
  bool isBookmarked = false;
}

@HiveType(typeId: 1)
class Verse {
  @HiveField(0)
  late int surahNumber;
  @HiveField(1)
  late int number;
  @HiveField(2)
  late String text;
  @HiveField(3)
  bool isMemorized = false;

  // Add this constructor
  Verse({
    required this.surahNumber,
    required this.number,
    required this.text,
    this.isMemorized = false,
  });
}

// ==================== USAGE EXAMPLES ====================
// void main() {
//   // Initialize once
//   LocalDB.init();

//   // Get/Set simple values
//   LocalDB.updateValue('darkMode', true);
//   bool isDarkMode = LocalDB.getValue('darkMode');

//   // Surah operations
//   SurahDB? surah = LocalDB.getSurah(1);
//   if (surah != null) {
//     surah.isBookmarked = true;
//     LocalDB.updateSurah(surah);
//   }

//   // Verse operations
//   List<Verse> verses = LocalDB.getVerses(1);
//   verses[0].isMemorized = true;
//   LocalDB.updateVerse(verses[0]);
// }

// ==================== HIVE ADAPTERS ====================
class SurahAdapter extends TypeAdapter<SurahDB> {
  @override
  final typeId = 0;

  @override
  SurahDB read(BinaryReader reader) {
    final surah = SurahDB()
      ..number = reader.read()
      ..name = reader.read()
      ..englishName = reader.read()
      ..isBookmarked = reader.read();
    return surah;
  }

  @override
  void write(BinaryWriter writer, SurahDB obj) {
    writer.write(obj.number);
    writer.write(obj.name);
    writer.write(obj.englishName);
    writer.write(obj.isBookmarked);
  }
}

class VerseAdapter extends TypeAdapter<Verse> {
  @override
  final typeId = 1;

  @override
  Verse read(BinaryReader reader) {
    final verse = Verse(
        surahNumber: reader.read(),
        number: reader.read(),
        text: reader.read(),
        isMemorized: reader.read());
    return verse;
  }

  @override
  void write(BinaryWriter writer, Verse obj) {
    writer.write(obj.surahNumber);
    writer.write(obj.number);
    writer.write(obj.text);
    writer.write(obj.isMemorized);
  }
}

// class LocalDB {
//   static final LocalDB _instance = LocalDB._internal();
//   static Database? _database;

//   factory LocalDB() => _instance;

//   LocalDB._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'quran_local.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE surahs (
//             id INTEGER PRIMARY KEY,
//             number INTEGER UNIQUE,
//             name TEXT,
//             englishName TEXT,
//             isBookmarked INTEGER DEFAULT 0,
//             lastRead INTEGER DEFAULT 0,
//             lastReadDate TEXT
//           )
//         ''');

//         await db.execute('''
//           CREATE TABLE verses (
//             id INTEGER PRIMARY KEY,
//             surahNumber INTEGER,
//             number INTEGER,
//             text TEXT,
//             translation TEXT,
//             isMemorized INTEGER DEFAULT 0,
//             FOREIGN KEY (surahNumber) REFERENCES surahs(number)
//           )
//         ''');

//         await db.execute('''
//           CREATE TABLE bookmarks (
//             id INTEGER PRIMARY KEY,
//             surahNumber INTEGER,
//             verseNumber INTEGER,
//             createdAt TEXT,
//             note TEXT
//           )
//         ''');
//       },
//     );
//   }

//   // ================ CRUD Operations ================

//   // Get single value
//   Future<dynamic> getValue(String table, String column, String where, List<dynamic> whereArgs) async {
//     final db = await database;
//     final result = await db.query(
//       table,
//       columns: [column],
//       where: where,
//       whereArgs: whereArgs,
//     );
//     return result.isNotEmpty ? result.first[column] : null;
//   }

//   // Update single value
//   Future<int> updateValue(String table, String column, dynamic value, String where, List<dynamic> whereArgs) async {
//     final db = await database;
//     return await db.update(
//       table,
//       {column: value},
//       where: where,
//       whereArgs: whereArgs,
//     );
//   }

//   // ================ Surah Operations ================
//   Future<List<Map<String, dynamic>>> getAllSurahs() async {
//     final db = await database;
//     return await db.query('surahs', orderBy: 'number ASC');
//   }

//   Future<Map<String, dynamic>?> getSurah(int number) async {
//     final db = await database;
//     final result = await db.query(
//       'surahs',
//       where: 'number = ?',
//       whereArgs: [number],
//     );
//     return result.isNotEmpty ? result.first : null;
//   }

//   Future<int> updateSurahBookmark(int number, bool isBookmarked) async {
//     return await updateValue(
//       'surahs',
//       'isBookmarked',
//       isBookmarked ? 1 : 0,
//       'number = ?',
//       [number],
//     );
//   }

//   // ================ Verse Operations ================
//   Future<List<Map<String, dynamic>>> getVerses(int surahNumber) async {
//     final db = await database;
//     return await db.query(
//       'verses',
//       where: 'surahNumber = ?',
//       whereArgs: [surahNumber],
//       orderBy: 'number ASC',
//     );
//   }

//   Future<int> updateVerseMemorization(int verseId, bool isMemorized) async {
//     return await updateValue(
//       'verses',
//       'isMemorized',
//       isMemorized ? 1 : 0,
//       'id = ?',
//       [verseId],
//     );
//   }

//   // ================ Bookmark Operations ================
//   Future<int> addBookmark(int surahNumber, int verseNumber, {String? note}) async {
//     final db = await database;
//     return await db.insert('bookmarks', {
//       'surahNumber': surahNumber,
//       'verseNumber': verseNumber,
//       'createdAt': DateTime.now().toIso8601String(),
//       'note': note ?? '',
//     });
//   }

//   Future<List<Map<String, dynamic>>> getBookmarks() async {
//     final db = await database;
//     return await db.query('bookmarks', orderBy: 'createdAt DESC');
//   }

//   Future<void> close() async {
//     if (_database != null) await _database!.close();
//   }
// }