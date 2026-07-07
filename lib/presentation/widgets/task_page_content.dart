import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../responsive/responsive_layout.dart';
import 'task_list_header.dart';
import 'task_list_section.dart';
import 'task_list_sidebar.dart';

class TaskPageContent extends StatelessWidget {
  const TaskPageContent({
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
    final header = TaskListHeader(controller: controller);
    final sidebar = TaskListSidebar(controller: controller);
    final list = TaskListSection(
      controller: controller,
      onCreateTask: onCreateTask,
      onSyncNow: onSyncNow,
    );

    if (ResponsiveLayout.isDesktop(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: list),
              const SizedBox(width: 22),
              SizedBox(width: 360, child: sidebar),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: 16),
        sidebar,
        const SizedBox(height: 18),
        list,
      ],
    );
  }
}
