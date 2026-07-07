import '../../domain/models/task.dart';

abstract class TaskLocalDataSource {
  String get storageEngineName;

  Future<void> init();

  Future<List<Task>> getTasks();
  Future<List<Task>> getVisibleTasks();
  Future<List<Task>> getPendingSyncTasks();

  Future<void> insertTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTaskPermanently(String id);

  Future<void> markTaskAsSynced(String id);
  Future<void> markTaskAsSyncError(String id);

  Future<void> upsertRemoteTask(Task task);
}
