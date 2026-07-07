import 'package:flutter/material.dart';
import 'package:offline_tasks_demo/data/local/task_local_datasource.dart';

import 'data/local/task_local_storage_factory.dart';
import 'data/remote/supabase_client.dart';
import 'data/remote/task_remote_datasource.dart';
import 'data/repositories/task_repository.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/pages/task_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TaskLocalDataSource localDataSource =
      await TaskLocalStorageFactory.create();
  final TaskRepository repository = TaskRepository(
    localDataSource: localDataSource,
    remoteDataSource: TaskRemoteDataSource(SupabaseRestClient()),
  );
  final TaskController controller = TaskController(repository);
  await controller.load();

  runApp(OfflineTasksDemoApp(controller: controller));
}

class OfflineTasksDemoApp extends StatelessWidget {
  const OfflineTasksDemoApp({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Tasks Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5BAE9D),
          primary: const Color(0xFF287C72),
          secondary: const Color(0xFFE16F52),
          tertiary: const Color(0xFF756B9A),
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFEAF3F1),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE1E8E5)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE16F52),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE7E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF5BAE9D), width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.6),
          ),
        ),
      ),
      home: TaskListPage(controller: controller),
    );
  }
}
