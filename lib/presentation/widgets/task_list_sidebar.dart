import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import 'about_demo_card.dart';
import 'inline_error.dart';

class TaskListSidebar extends StatelessWidget {
  const TaskListSidebar({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.errorMessage != null) ...[
          InlineError(message: controller.errorMessage!),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 14),
        const AboutDemoCard(),
      ],
    );
  }
}
