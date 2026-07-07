import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../controllers/task_controller.dart';
import 'empty_task_list_card.dart';
import 'sync_status_line.dart';
import 'task_form_dialog.dart';
import 'task_tile.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.controller,
    required this.onCreateTask,
    required this.onSyncNow,
  });

  final TaskController controller;
  final VoidCallback onCreateTask;
  final VoidCallback onSyncNow;

  @override
  Widget build(BuildContext context) {
    if (controller.tasks.isEmpty) {
      return EmptyTaskListCard(onCreateTask: onCreateTask);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TaskListSectionHeader(
          controller: controller,
          onCreateTask: onCreateTask,
          onSyncNow: onSyncNow,
        ),
        const SizedBox(height: 14),
        for (final task in controller.tasks)
          TaskTile(
            task: task,
            onToggle: () => controller.toggleCompleted(task),
            onEdit: () => _editTask(context, task),
            onDelete: () => controller.deleteTask(task),
          ),
      ],
    );
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    final result = await TaskFormDialog.show(context, task: task);
    if (result == null) {
      return;
    }
    await controller.updateTask(task, result.title, result.description);
  }
}

class _TaskListSectionHeader extends StatelessWidget {
  const _TaskListSectionHeader({
    required this.controller,
    required this.onCreateTask,
    required this.onSyncNow,
  });

  final TaskController controller;
  final VoidCallback onCreateTask;
  final VoidCallback onSyncNow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;
        final title = _SectionTitle(taskCount: controller.tasks.length);
        final action = _NewTaskButton(onPressed: onCreateTask);
        final syncStatus = SyncStatusLine(
          controller: controller,
          onSyncNow: onSyncNow,
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 12),
                  action,
                ],
              ),
              const SizedBox(height: 10),
              syncStatus,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: title),
            const SizedBox(width: 18),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: syncStatus,
              ),
            ),
            const SizedBox(width: 12),
            action,
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.taskCount});

  final int taskCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tareas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF202725),
                  ),
            ),
            const SizedBox(width: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  taskCount.toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Se guardan localmente y se sincronizan en segundo plano.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.25,
              ),
        ),
      ],
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  const _NewTaskButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Nueva tarea'),
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
