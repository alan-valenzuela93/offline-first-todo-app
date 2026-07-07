import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import 'stat_pill.dart';

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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8EAE5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 760;
            final titleBlock = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Tasks Demo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF202725),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tareas locales primero, sincronizacion automatica despues.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                ),
              ],
            );

            final stats = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatPill(
                  icon: Icons.list_alt_outlined,
                  label: 'Tareas',
                  value: controller.tasks.length.toString(),
                ),
                StatPill(
                  icon: Icons.done_all_outlined,
                  label: 'Completadas',
                  value: completed.toString(),
                ),
                StatPill(
                  icon: Icons.schedule_outlined,
                  label: 'Pendientes',
                  value: pending.toString(),
                  accent: colorScheme.secondaryContainer,
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
