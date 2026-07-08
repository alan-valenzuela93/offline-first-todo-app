import 'package:flutter/material.dart';
import 'package:offline_tasks_demo/presentation/pages/task_list_page/widgets/task_tile/task_tile_actions.dart';
import 'package:offline_tasks_demo/presentation/pages/task_list_page/widgets/task_tile/task_tile_content.dart';
import '../../../../../domain/models/task.dart';
import 'task_checkbox.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isCompact = MediaQuery.sizeOf(context).width < 560;
    final Color statusColor = task.completed
        ? const Color(0xFF10B981)
        : task.syncStatus.name.startsWith('pending')
        ? const Color(0xFFF59E0B)
        : task.syncStatus.name == 'syncError'
        ? colorScheme.error
        : colorScheme.primary;

    final TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!
        .copyWith(
          fontWeight: FontWeight.w900,
          color: task.completed
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurface,
          decoration: task.completed ? TextDecoration.lineThrough : null,
          decorationThickness: 2,
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                    ),
                    child: const SizedBox(width: 6),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: isCompact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TaskCheckbox(
                                      value: task.completed,
                                      onChanged: onToggle,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TaskTileContent(
                                        task: task,
                                        titleStyle: titleStyle,
                                        colorScheme: colorScheme,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TaskTileActions(
                                    onEdit: onEdit,
                                    onDelete: onDelete,
                                    colorScheme: colorScheme,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TaskCheckbox(
                                  value: task.completed,
                                  onChanged: onToggle,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TaskTileContent(
                                    task: task,
                                    titleStyle: titleStyle,
                                    colorScheme: colorScheme,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TaskTileActions(
                                  onEdit: onEdit,
                                  onDelete: onDelete,
                                  colorScheme: colorScheme,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
