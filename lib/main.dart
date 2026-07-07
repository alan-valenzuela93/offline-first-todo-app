import 'package:flutter/material.dart';
import 'package:offline_tasks_demo/data/local/task_local_datasource.dart';

import 'data/local/task_local_storage_factory.dart';
import 'data/remote/supabase_client.dart';
import 'data/remote/task_remote_datasource.dart';
import 'data/repositories/task_repository.dart';
import 'presentation/app/offline_tasks_bootstrap.dart';
import 'presentation/controllers/task_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OfflineTasksBootstrap(controllerLoader: _createController()));
}

Future<TaskController> _createController() async {
  final TaskLocalDataSource localDataSource =
      await TaskLocalStorageFactory.create();
  final TaskRepository repository = TaskRepository(
    localDataSource: localDataSource,
    remoteDataSource: TaskRemoteDataSource(SupabaseRestClient()),
  );
  final TaskController controller = TaskController(repository);
  await controller.load();
  return controller;
}
