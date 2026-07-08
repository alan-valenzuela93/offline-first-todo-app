import 'package:flutter/material.dart';

import '../../../../controllers/task_controller.dart';
import '../../../../widgets/stat_pill.dart';

class TaskListHeader extends StatelessWidget {
  const TaskListHeader({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completed = controller.tasks.where((task) => task.completed).length;
    final pending = controller.tasks
        .where((task) => task.syncStatus.name.startsWith('pending'))
        .length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.35),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primaryContainer.withOpacity(0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 760;
            final titleBlock = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Tasks Demo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tareas locales primero, sincronización automática después.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            );

            final stats = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                StatPill(
                  icon: Icons.list_alt_rounded,
                  label: 'Tareas',
                  value: controller.tasks.length.toString(),
                  accent: colorScheme.primaryContainer,
                  iconColor: colorScheme.primary,
                ),
                StatPill(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Completadas',
                  value: completed.toString(),
                  accent: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                ),
                StatPill(
                  icon: Icons.hourglass_empty_rounded,
                  label: 'Pendientes',
                  value: pending.toString(),
                  accent: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFD97706),
                ),
              ],
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [titleBlock, const SizedBox(height: 14), stats],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleBlock),
                const SizedBox(width: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: stats,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
