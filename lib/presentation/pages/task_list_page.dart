import 'package:flutter/material.dart';

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
          appBar: const _GradientAppBar(),
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

class _GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GradientAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1F6F66),
            Color(0xFF287C72),
            Color(0xFF3E9A89),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F1F6F66),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Offline Tasks Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
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
