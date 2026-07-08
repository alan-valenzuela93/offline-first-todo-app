import 'package:flutter/foundation.dart';

import '../../data/repositories/task_repository.dart';
import '../../domain/models/task.dart';

enum SyncUiState { idle, syncing, synced, localOnly, error }

class TaskController extends ChangeNotifier {
  TaskController(this._repository);

  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;
  SyncUiState _syncUiState = SyncUiState.idle;
  String _syncMessage = 'Los cambios se guardan primero en este navegador.';

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;
  String get storageEngineName => _repository.storageEngineName;
  SyncUiState get syncUiState => _syncUiState;
  String get syncMessage => _syncMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _tasks = await _repository.getTasks();
    } catch (error) {
      _errorMessage = 'No se pudieron cargar las tareas: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    await _syncSilently();
  }

  Future<void> createTask(String title, String? description) async {
    await _runAndReload(() => _repository.createTask(title, description));
  }

  Future<void> updateTask(Task task, String title, String? description) async {
    await _runAndReload(
      () => _repository.updateTask(
        task.copyWith(
          title: title.trim(),
          description: _normalize(description),
        ),
      ),
    );
  }

  Future<void> toggleCompleted(Task task) async {
    await _runAndReload(() => _repository.toggleCompleted(task));
  }

  Future<void> deleteTask(Task task) async {
    await _runAndReload(() => _repository.deleteTask(task));
  }

  Future<SyncResult> sync() async {
    _isSyncing = true;
    _syncUiState = SyncUiState.syncing;
    _syncMessage = 'Sincronizando cambios...';
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.sync();
      _tasks = await _repository.getTasks();
      _applySyncResult(result);
      return result;
    } catch (error) {
      final result = SyncResult(
        success: false,
        syncedItems: 0,
        failedItems: 1,
        message: 'No se pudo sincronizar: $error',
      );
      _errorMessage = result.message;
      _syncUiState = SyncUiState.error;
      _syncMessage = 'No se pudo sincronizar. Los cambios siguen locales.';
      return result;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _runAndReload(Future<void> Function() action) async {
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _tasks = await _repository.getTasks();
    } catch (error) {
      _errorMessage = 'La operacion no se pudo completar: $error';
    } finally {
      notifyListeners();
    }
    await _syncSilently();
  }

  Future<void> _syncSilently() async {
    if (_isSyncing) {
      return;
    }
    _isSyncing = true;
    _syncUiState = SyncUiState.syncing;
    _syncMessage = 'Sincronizando cambios...';
    notifyListeners();
    try {
      final result = await _repository.sync();
      _tasks = await _repository.getTasks();
      _applySyncResult(result);
    } catch (_) {
      _syncUiState = SyncUiState.error;
      _syncMessage = 'No se pudo sincronizar. Los cambios siguen locales.';
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  void _applySyncResult(SyncResult result) {
    if (result.success) {
      _errorMessage = null;
      _syncUiState = SyncUiState.synced;
      _syncMessage = result.syncedItems > 0
          ? 'Sincronizado hace un momento.'
          : 'Todo al dia.';
      return;
    }

    final String lowerMessage = result.message.toLowerCase();
    final bool isLocalOnly =
        lowerMessage.contains('supabase no esta configurado') ||
        lowerMessage.contains('sin conexion');

    if (isLocalOnly) {
      _syncUiState = SyncUiState.localOnly;
      _syncMessage =
          'Cambios guardados localmente. Se sincronizaran al estar listo.';
      return;
    }

    _syncUiState = SyncUiState.error;
    _syncMessage =
        'Hubo un problema al sincronizar. Tus cambios siguen locales.';
  }

  String? _normalize(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
