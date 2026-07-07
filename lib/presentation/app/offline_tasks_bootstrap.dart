import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/startup/startup_error_screen.dart';
import '../widgets/startup/startup_loading_screen.dart';
import 'offline_tasks_demo_app.dart';

class OfflineTasksBootstrap extends StatelessWidget {
  const OfflineTasksBootstrap({super.key, required this.controllerLoader});

  final Future<TaskController> controllerLoader;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TaskController>(
      future: controllerLoader,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return OfflineTasksDemoApp(controller: snapshot.requireData);
        }

        return MaterialApp(
          title: 'Offline Tasks Demo',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: snapshot.hasError
              ? const StartupErrorScreen()
              : const StartupLoadingScreen(),
        );
      },
    );
  }
}
