enum SyncStatus {
  synced,
  pendingCreate,
  pendingUpdate,
  pendingDelete,
  syncError,
}

extension SyncStatusX on SyncStatus {
  String get label {
    return switch (this) {
      SyncStatus.synced => 'Sincronizado',
      SyncStatus.pendingCreate => 'Guardado localmente',
      SyncStatus.pendingUpdate => 'Cambios locales',
      SyncStatus.pendingDelete => 'Eliminacion pendiente',
      SyncStatus.syncError => 'No sincronizado',
    };
  }

  static SyncStatus fromName(String value) {
    return SyncStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SyncStatus.syncError,
    );
  }
}
