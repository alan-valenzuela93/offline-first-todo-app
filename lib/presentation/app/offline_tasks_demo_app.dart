import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../pages/task_list_page/task_list_page.dart';
import '../theme/app_theme.dart';

class OfflineTasksDemoApp extends StatelessWidget {
  const OfflineTasksDemoApp({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Tasks Demo',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: TaskListPage(controller: controller),
    );
  }
}
