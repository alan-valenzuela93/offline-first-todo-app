import 'package:flutter_test/flutter_test.dart';
import 'package:offline_tasks_demo/domain/models/sync_status.dart';
import 'package:offline_tasks_demo/domain/models/task.dart';

void main() {
  test('Task local and remote mapping keeps sync status local only', () {
    final now = DateTime.utc(2026, 7, 7, 10);
    final task = Task(
      id: '6f6821f0-7b45-4db4-b1a7-0b22cd8185b0',
      title: 'Crear una tarea offline',
      description: 'Demo',
      completed: true,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
      syncStatus: SyncStatus.pendingCreate,
    );

    final local = task.toLocalJson();
    final remote = task.toRemoteJson();

    expect(Task.fromLocalJson(local).syncStatus, SyncStatus.pendingCreate);
    expect(local['completed'], 1);
    expect(remote.containsKey('sync_status'), isFalse);
    expect(remote['completed'], isTrue);
  });
}
