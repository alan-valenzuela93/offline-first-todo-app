import 'package:flutter/foundation.dart';

import 'browser_fallback_task_local_datasource.dart';
import 'sqflite_task_local_datasource.dart';
import 'task_local_datasource.dart';

class TaskLocalStorageFactory {
  static Future<TaskLocalDataSource> create() async {
    try {
      final sqlite = SqfliteTaskLocalDataSource();
      await sqlite.init();
      return sqlite;
    } catch (error, stackTrace) {
      debugPrint('SQLite Web no pudo inicializarse: $error');
      debugPrintStack(stackTrace: stackTrace);
      final fallback = BrowserFallbackTaskLocalDataSource();
      await fallback.init();
      return fallback;
    }
  }
}
