import 'package:dio/dio.dart';

import '../../config/supabase_config.dart';
import '../../domain/models/task.dart';
import 'supabase_client.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource(this._client);

  final SupabaseRestClient _client;

  Future<List<Task>> getUpdatedTasks(DateTime? lastSyncAt) async {
    _ensureConfigured();
    final query = <String, Object?>{
      'select': '*',
      'order': 'updated_at.asc',
      if (lastSyncAt != null)
        'updated_at': 'gt.${lastSyncAt.toUtc().toIso8601String()}',
    };
    final response = await _client.dio.get<List<dynamic>>(
      '/tasks',
      queryParameters: query,
    );
    final rows = response.data ?? [];
    return rows
        .map(
          (row) => Task.fromRemoteJson(Map<String, Object?>.from(row as Map)),
        )
        .toList();
  }

  Future<void> createTask(Task task) async {
    _ensureConfigured();
    await _client.dio.post<void>(
      '/tasks',
      data: task.toRemoteJson(),
      options: Options(headers: {'Prefer': 'return=representation'}),
    );
  }

  Future<void> updateTask(Task task) async {
    _ensureConfigured();
    await _client.dio.patch<void>(
      '/tasks',
      queryParameters: {'id': 'eq.${task.id}'},
      data: task.toRemoteJson()..remove('id'),
    );
  }

  Future<void> deleteTask(String id) async {
    _ensureConfigured();
    await _client.dio.delete<void>('/tasks', queryParameters: {'id': 'eq.$id'});
  }

  void _ensureConfigured() {
    if (!SupabaseConfig.isConfigured) {
      throw StateError(
        'Configura SupabaseConfig.projectUrl y SupabaseConfig.anonKey antes de sincronizar.',
      );
    }
  }
}
