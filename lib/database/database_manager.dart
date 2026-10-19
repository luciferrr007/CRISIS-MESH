import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/mesh_message.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();

  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'crisis_mesh.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE mesh_messages (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        ttl INTEGER NOT NULL,
        hop_count INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertMessage(
      MeshMessage message,
      ) async {
    final db = await database;

    return await db.insert(
      'mesh_messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MeshMessage>> getMessages() async {
    final db = await database;

    final result = await db.query(
      'mesh_messages',
      orderBy: 'created_at DESC',
    );

    return result
        .map(
          (map) => MeshMessage.fromMap(map),
    )
        .toList();
  }

  Future<MeshMessage?> getMessage(
      String id,
      ) async {
    final db = await database;

    final result = await db.query(
      'mesh_messages',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return MeshMessage.fromMap(result.first);
  }

  Future<int> updateMessage(
      MeshMessage message,
      ) async {
    final db = await database;

    return await db.update(
      'mesh_messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> deleteMessage(
      String id,
      ) async {
    final db = await database;

    return await db.delete(
      'mesh_messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();

    _database = null;
  }
}