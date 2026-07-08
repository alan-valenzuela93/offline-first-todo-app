import 'package:flutter/material.dart';
import 'package:offline_tasks_demo/domain/models/task.dart';
import 'package:offline_tasks_demo/presentation/widgets/sync_status/sync_status_badge.dart';

class TaskTileContent extends StatelessWidget {
  const TaskTileContent({
    super.key,
    required this.task,
    required this.titleStyle,
    required this.colorScheme,
  });

  final Task task;
  final TextStyle titleStyle;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(task.title, style: titleStyle),
            SyncStatusBadge(status: task.syncStatus),
          ],
        ),
        if (task.description != null) ...[
          const SizedBox(height: 7),
          Text(
            task.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}
