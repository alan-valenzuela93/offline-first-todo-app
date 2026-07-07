import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../config/supabase_config.dart';
import '../../domain/models/sync_status.dart';
import '../../domain/models/task.dart';
import '../local/task_local_datasource.dart';
import '../remote/task_remote_datasource.dart';

class SyncResult {
  final bool success;
  final int syncedItems;
  final int failedItems;
  final String message;

  const SyncResult({
    required this.success,
    required this.syncedItems,
    required this.failedItems,
    required this.message,
  });
}

class TaskRepository {
  TaskRepository({
    required TaskLocalDataSource localDataSource,
    required TaskRemoteDataSource remoteDataSource,
  }) : _local = localDataSource,
       _remote = remoteDataSource;

  static const String _lastSyncKey = 'offline_tasks_demo_last_sync_at';

  final TaskLocalDataSource _local;
  final TaskRemoteDataSource _remote;
  final Uuid _uuid = const Uuid();

  String get storageEngineName => _local.storageEngineName;

  Future<List<Task>> getTasks() async {
    return _local.getVisibleTasks();
  }

  Future<void> createTask(String title, String? description) async {
    final now = DateTime.now().toUtc();
    await _local.insertTask(
      Task(
        id: _uuid.v4(),
        title: title.trim(),
        description: _normalizeDescription(description),
        completed: false,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
        syncStatus: SyncStatus.pendingCreate,
      ),
    );
  }

  Future<void> updateTask(Task task) async {
    final status = switch (task.syncStatus) {
      SyncStatus.pendingCreate => SyncStatus.pendingCreate,
      _ => SyncStatus.pendingUpdate,
    };
    await _local.updateTask(
      task.copyWith(updatedAt: DateTime.now().toUtc(), syncStatus: status),
    );
  }

  Future<void> toggleCompleted(Task task) async {
    await updateTask(task.copyWith(completed: !task.completed));
  }

  Future<void> deleteTask(Task task) async {
    if (task.syncStatus == SyncStatus.pendingCreate) {
      await _local.deleteTaskPermanently(task.id);
      return;
    }
    await _local.updateTask(
      task.copyWith(
        updatedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        syncStatus: SyncStatus.pendingDelete,
      ),
    );
  }

  Future<SyncResult> sync() async {
    if (!SupabaseConfig.isConfigured) {
      return const SyncResult(
        success: false,
        syncedItems: 0,
        failedItems: 0,
        message: 'Supabase no esta configurado. Los cambios siguen locales.',
      );
    }

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return const SyncResult(
        success: false,
        syncedItems: 0,
        failedItems: 0,
        message: 'Sin conexion. Los cambios quedan guardados localmente.',
      );
    }

    var synced = 0;
    var failed = 0;
    final pendingTasks = await _local.getPendingSyncTasks();

    for (final task in pendingTasks) {
      try {
        switch (task.syncStatus) {
          case SyncStatus.pendingCreate:
            await _remote.createTask(task);
            await _local.markTaskAsSynced(task.id);
          case SyncStatus.pendingUpdate:
          case SyncStatus.syncError:
            await _remote.updateTask(task);
            await _local.markTaskAsSynced(task.id);
          case SyncStatus.pendingDelete:
            await _remote.deleteTask(task.id);
            await _local.deleteTaskPermanently(task.id);
          case SyncStatus.synced:
            continue;
        }
        synced++;
      } catch (_) {
        failed++;
        if (task.syncStatus != SyncStatus.pendingDelete) {
          await _local.markTaskAsSyncError(task.id);
        }
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = _readLastSyncAt(prefs);
      final remoteTasks = await _remote.getUpdatedTasks(lastSync);
      final localTasks = await _local.getTasks();
      final localById = {for (final task in localTasks) task.id: task};

      for (final remoteTask in remoteTasks) {
        final localTask = localById[remoteTask.id];
        if (localTask == null) {
          await _local.upsertRemoteTask(remoteTask);
          synced++;
          continue;
        }

        // Last-write-wins simple: remote only replaces local when local has no
        // pending work. Pending local changes win in this portfolio demo.
        final canApplyRemote =
            localTask.syncStatus == SyncStatus.synced &&
            remoteTask.updatedAt.isAfter(localTask.updatedAt);
        if (canApplyRemote) {
          if (remoteTask.deletedAt != null) {
            await _local.deleteTaskPermanently(remoteTask.id);
          } else {
            await _local.upsertRemoteTask(remoteTask);
          }
          synced++;
        }
      }

      await prefs.setString(
        _lastSyncKey,
        DateTime.now().toUtc().toIso8601String(),
      );
    } catch (_) {
      failed++;
    }

    final success = failed == 0;
    return SyncResult(
      success: success,
      syncedItems: synced,
      failedItems: failed,
      message: success
          ? 'Sincronizacion completa. $synced cambios procesados.'
          : 'Sincronizacion finalizada con $failed error(es).',
    );
  }

  DateTime? _readLastSyncAt(SharedPreferences prefs) {
    final raw = prefs.getString(_lastSyncKey);
    if (raw == null) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  String? _normalizeDescription(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
