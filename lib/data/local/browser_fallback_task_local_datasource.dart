import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/sync_status.dart';
import '../../domain/models/task.dart';
import 'task_local_datasource.dart';

class BrowserFallbackTaskLocalDataSource implements TaskLocalDataSource {
  static const String _tasksKey = 'offline_tasks_demo_tasks';

  SharedPreferences? _prefs;

  @override
  String get storageEngineName => 'Browser fallback';

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _store {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('Browser fallback no fue inicializado.');
    }
    return prefs;
  }

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await _readTasks();
    return tasks..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<Task>> getVisibleTasks() async {
    final tasks = await _readTasks();
    return tasks
        .where((task) => task.syncStatus != SyncStatus.pendingDelete)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<Task>> getPendingSyncTasks() async {
    final tasks = await _readTasks();
    return tasks.where((task) => task.syncStatus != SyncStatus.synced).toList()
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
  }

  @override
  Future<void> insertTask(Task task) async {
    final tasks = await _readTasks();
    final index = tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      tasks.add(task);
    } else {
      tasks[index] = task;
    }
    await _writeTasks(tasks);
  }

  @override
  Future<void> updateTask(Task task) => insertTask(task);

  @override
  Future<void> deleteTaskPermanently(String id) async {
    final tasks = await _readTasks();
    tasks.removeWhere((task) => task.id == id);
    await _writeTasks(tasks);
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

  Future<List<Task>> _readTasks() async {
    final raw = _store.getString(_tasksKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (item) => Task.fromLocalJson(Map<String, Object?>.from(item as Map)),
        )
        .toList();
  }

  Future<void> _writeTasks(List<Task> tasks) async {
    final raw = jsonEncode(tasks.map((task) => task.toLocalJson()).toList());
    await _store.setString(_tasksKey, raw);
  }

  Future<void> _setSyncStatus(String id, SyncStatus status) async {
    final tasks = await _readTasks();
    final index = tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return;
    }
    tasks[index] = tasks[index].copyWith(syncStatus: status);
    await _writeTasks(tasks);
  }
}
