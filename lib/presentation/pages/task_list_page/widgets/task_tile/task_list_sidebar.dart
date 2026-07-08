import 'package:flutter/material.dart';

import '../../../../controllers/task_controller.dart';
import '../../../../widgets/about_demo_card.dart';
import '../../../../widgets/inline_error.dart';

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
          const SizedBox(height: 16),
        ],
        const AboutDemoCard(),
      ],
    );
  }
}
