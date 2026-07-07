import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../controllers/task_controller.dart';
import 'empty_task_list_card.dart';
import 'task_form_dialog.dart';
import 'task_list_section/task_list_section_header.dart';
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
        TaskListSectionHeader(
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
