import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../domain/models/sync_status.dart';
import '../../domain/models/task.dart';
import 'task_local_datasource.dart';

class SqfliteTaskLocalDataSource implements TaskLocalDataSource {
  Database? _database;

  @override
  String get storageEngineName => 'SQLite Web';

  @override
  Future<void> init() async {
    final options = SqfliteFfiWebOptions(
      sqlite3WasmUri: Uri.base.resolve('sqlite3.wasm'),
      sharedWorkerUri: Uri.base.resolve('sqflite_sw.js'),
      indexedDbName: 'offline_tasks_demo',
    );

    try {
      _database = await _openDatabase(
        createDatabaseFactoryFfiWeb(options: options),
      );
    } catch (_) {
      // If the worker cannot be loaded, still try SQLite Web directly before
      // falling back to shared_preferences at the factory level.
      _database = await _openDatabase(
        createDatabaseFactoryFfiWeb(options: options, noWebWorker: true),
      );
    }
  }

  Future<Database> _openDatabase(DatabaseFactory factory) {
    return factory.openDatabase(
      'offline_tasks_demo.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
create table tasks (
  id text primary key,
  title text not null,
  description text,
  completed integer not null,
  created_at text not null,
  updated_at text not null,
  deleted_at text,
  sync_status text not null
)
''');
        },
      ),
    );
  }

  Database get _db {
    final db = _database;
    if (db == null) {
      throw StateError('SQLite Web no fue inicializado.');
    }
    return db;
  }

  @override
  Future<List<Task>> getTasks() async {
    final rows = await _db.query('tasks', orderBy: 'updated_at desc');
    return rows.map(Task.fromLocalJson).toList();
  }

  @override
  Future<List<Task>> getVisibleTasks() async {
    final rows = await _db.query(
      'tasks',
      where: 'sync_status != ?',
      whereArgs: [SyncStatus.pendingDelete.name],
      orderBy: 'created_at desc',
    );
    return rows.map(Task.fromLocalJson).toList();
  }

  @override
  Future<List<Task>> getPendingSyncTasks() async {
    final rows = await _db.query(
      'tasks',
      where: 'sync_status in (?, ?, ?, ?)',
      whereArgs: [
        SyncStatus.pendingCreate.name,
        SyncStatus.pendingUpdate.name,
        SyncStatus.pendingDelete.name,
        SyncStatus.syncError.name,
      ],
      orderBy: 'updated_at asc',
    );
    return rows.map(Task.fromLocalJson).toList();
  }

  @override
  Future<void> insertTask(Task task) async {
    await _db.insert(
      'tasks',
      task.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await _db.update(
      'tasks',
      task.toLocalJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTaskPermanently(String id) async {
    await _db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> markTaskAsSynced(String id) async {
    await _setSyncStatus(id, SyncStatus.synced);
  }

  @override
  Future<void> markTaskAsSyncError(String id) async {
    await _setSyncStatus(id, SyncStatus.syncError);
  }

  @override
  Future<void> upsertRemoteTask(Task task) async {
    await insertTask(task.copyWith(syncStatus: SyncStatus.synced));
  }

  Future<void> _setSyncStatus(String id, SyncStatus status) async {
    await _db.update(
      'tasks',
      {'sync_status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
