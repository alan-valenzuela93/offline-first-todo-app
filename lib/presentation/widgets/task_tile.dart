import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import 'sync_status_badge.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isCompact = MediaQuery.sizeOf(context).width < 560;
    final statusColor = task.completed
        ? const Color(0xFF287C72)
        : task.syncStatus.name.startsWith('pending')
        ? const Color(0xFFE16F52)
        : task.syncStatus.name == 'syncError'
        ? colorScheme.error
        : colorScheme.primary;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w900,
      color: task.completed
          ? colorScheme.onSurfaceVariant
          : colorScheme.onSurface,
      decoration: task.completed ? TextDecoration.lineThrough : null,
      decorationThickness: 2,
    );

    final content = Column(
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

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: 'Editar',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: 'Eliminar',
          onPressed: onDelete,
          color: colorScheme.error,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE1E8E5)),
        ),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(14),
                    ),
                  ),
                  child: const SizedBox(width: 5),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: isCompact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _TaskCheckbox(
                                    value: task.completed,
                                    onChanged: onToggle,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: content),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: actions,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TaskCheckbox(
                                value: task.completed,
                                onChanged: onToggle,
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: content),
                              const SizedBox(width: 12),
                              actions,
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCheckbox extends StatelessWidget {
  const _TaskCheckbox({required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 42,
      child: Checkbox(
        value: value,
        shape: const CircleBorder(),
        side: const BorderSide(width: 1.7, color: Color(0xFF6D7D7A)),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
