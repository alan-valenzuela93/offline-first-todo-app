import 'sync_status.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.syncStatus,
  });

  Task copyWith({
    String? id,
    String? title,
    Object? description = _unchanged,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _unchanged,
    SyncStatus? syncStatus,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unchanged)
          ? this.description
          : description as String?,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: identical(deletedAt, _unchanged)
          ? this.deletedAt
          : deletedAt as DateTime?,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  factory Task.fromLocalJson(Map<String, Object?> json) {
    final completedValue = json['completed'];
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: completedValue is bool ? completedValue : completedValue == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: _parseOptionalDate(json['deleted_at']),
      syncStatus: SyncStatusX.fromName(json['sync_status'] as String),
    );
  }

  Map<String, Object?> toLocalJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
      'sync_status': syncStatus.name,
    };
  }

  factory Task.fromRemoteJson(Map<String, Object?> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: (json['completed'] as bool?) ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: _parseOptionalDate(json['deleted_at']),
      syncStatus: SyncStatus.synced,
    );
  }

  Map<String, Object?> toRemoteJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
    };
  }

  static DateTime? _parseOptionalDate(Object? value) {
    if (value == null || value == '') {
      return null;
    }
    return DateTime.parse(value as String);
  }
}

const Object _unchanged = Object();
