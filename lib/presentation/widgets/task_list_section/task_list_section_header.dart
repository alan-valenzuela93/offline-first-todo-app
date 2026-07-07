import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../sync_status/sync_status_line.dart';
import 'new_task_button.dart';
import 'section_title.dart';

class TaskListSectionHeader extends StatelessWidget {
  const TaskListSectionHeader({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;
        final title = SectionTitle(taskCount: controller.tasks.length);
        final action = NewTaskButton(onPressed: onCreateTask);
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
