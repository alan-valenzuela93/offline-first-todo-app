import 'package:flutter/material.dart';
import 'package:offline_tasks_demo/presentation/widgets/appbar/gradient_app_bar.dart';

import '../controllers/task_controller.dart';
import '../widgets/responsive_page_container.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_page_content.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: const GradientAppBar(),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: controller.load,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ResponsivePageContainer(
                        child: TaskPageContent(
                          controller: controller,
                          onCreateTask: () => _createTask(context),
                          onSyncNow: () => _syncNow(context),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _createTask(BuildContext context) async {
    final result = await TaskFormDialog.show(context);
    if (result == null) {
      return;
    }
    await controller.createTask(result.title, result.description);
  }

  Future<void> _syncNow(BuildContext context) async {
    final result = await controller.sync();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success
            ? null
            : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
